require 'pp'

# We're simply adding the #jenks method to the array class. "jenks" is a pretty
# unique word, and the author believes it probably won't be overwritten by
# anything. Probably.
class Array
  # # [Jenks natural breaks optimization](http:#en.wikipedia.org/wiki/Jenks_natural_breaks_optimization)
  #
  # Implementations: [1](http:#danieljlewis.org/files/2010/06/Jenks.pdf) (python),
  # [2](https:#github.com/vvoovv/djeo-jenks/blob/master/main.js) (buggy),
  # [3](https:#github.com/simogeo/geostats/blob/master/lib/geostats.js#L407) (works)
  #
  # Depends on `jenksBreaks()` and `jenksMatrices()`
  def jenks(n_classes)
    if n_classes > length
      return nil
    end

    # sort data in numerical order, since this is expected
    # by the matrices function
    data = self.sort

    # get our basic matrices
    matrices = jenksMatrices(data, n_classes)
    # puts matrices if data.length > 3 && n_classes == 3
    # we only need lower class limits here
    lower_class_limits = matrices[:lower_class_limits]

    # extract n_classes out of the computed matrices
    return jenksBreaks(data, lower_class_limits, n_classes)
  end

private

  # ## Compute Matrices for Jenks
  #
  # Compute the matrices required for Jenks breaks. These matrices
  # can be used for any classing of data with `classes <= n_classes`
  def jenksMatrices(data, n_classes)
    # in the original implementation, these matrices are referred to
    # as `LC` and `OP`
    #
    # * lower_class_limits (LC): optimal lower class limits
    # * variance_combinations (OP): optimal variance combinations for all classes
    lower_class_limits = []
    variance_combinations = []
    i = 0
    j = 0
    variance = 0

    # Initialize and fill each matrix with zeroes
    for i in 0..(data.length + 1)
      tmp1 = []
      tmp2 = []
      # despite these arrays having the same values, we need
      # to keep them separate so that changing one does not change
      # the other
      for j in 0..(n_classes + 1)
        tmp1 << 0
        tmp2 << 0
      end
      lower_class_limits << tmp1
      variance_combinations << tmp2
    end

    for i in 1..n_classes
      lower_class_limits[1][i] = 1
      variance_combinations[1][i] = 0
      # in the original implementation, 9999999 is used but
      # since Javascript has `Infinity`, we use that.
      for j in 2..data.length
        variance_combinations[j][i] = Float::INFINITY
      end
    end

    for l in 2..data.length
      # `SZ` originally. this is the sum of the values seen thus
      # far when calculating variance.
      sum = 0
      # `ZSQ` originally. the sum of squares of values seen
      # thus far
      sum_squares = 0
      # `WT` originally. This is the number of
      w = 0
      # `IV` originally
      i4 = 0

      # in several instances, you could say `Math.pow(x, 2)`
      # instead of `x * x`, but this is slower in some browsers
      # introduces an unnecessary concept.
      m = 0
      while m < l + 1
        m = m + 1
        # `III` originally
        lower_class_limit = l - m + 1
        val = data[lower_class_limit - 1]

        # here we're estimating variance for each potential classing
        # of the data, for each potential number of classes. `w`
        # is the number of data points considered so far.
        w += 1

        # increase the current sum and sum-of-squares
        sum += val
        sum_squares += val * val

        # the variance at this point in the sequence is the difference
        # between the sum of squares and the total x 2, over the number
        # of samples.
        variance = sum_squares - (sum * sum) / w

        i4 = lower_class_limit - 1

        if i4 != 0
          for j in 2..n_classes
            # if adding this element to an existing class
            # will increase its variance beyond the limit, break
            # the class at this point, setting the `lower_class_limit`
            # at this point.
            if (variance_combinations[l][j] >= (variance + variance_combinations[i4][j - 1]))
              lower_class_limits[l][j] = lower_class_limit
              variance_combinations[l][j] = variance + variance_combinations[i4][j - 1]
            end
          end
        end
      end

      lower_class_limits[l][1] = 1
      variance_combinations[l][1] = variance
    end

    # return the two matrices. for just providing breaks, only
    # `lower_class_limits` is needed, but variances can be useful to
    # evaluate goodness of fit.
    return {
      lower_class_limits: lower_class_limits,
      variance_combinations: variance_combinations
    }
  end

  # ## Pull Breaks Values for Jenks
  #
  # the second part of the jenks recipe: take the calculated matrices
  # and derive an array of n breaks.
  def jenksBreaks(data, lower_class_limits, n_classes)
    k = data.length - 1
    kclass = []
    countNum = n_classes

    # the calculation of classes will never include the upper and
    # lower bounds, so we need to explicitly set them
    kclass[n_classes] = data[data.length - 1]
    kclass[0] = data[0]

    # the lower_class_limits matrix is used as indices into itself
    # here: the `k` variable is reused in each iteration.
    while countNum > 1
      kclass[countNum - 1] = data[lower_class_limits[k][countNum] - 2]
      k = lower_class_limits[k][countNum] - 1
      countNum -= 1
    end

    return kclass
  end
end
