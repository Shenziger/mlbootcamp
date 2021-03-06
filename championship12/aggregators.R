colmat = function (X, idxes) {
  res = rep(NA, nrow(X))
  for (i in 1:nrow(X)) {
    res[i] = X[i, idxes[i]]
  }
  res
}

is.sorted = function (x) {
  !is.unsorted(x)
}

meanAggregator = function (baseAlgos, w=NULL) {
  l = length(baseAlgos)
  if (is.null(w))
    w = rep(1/l, l)
  else if (sum(w) != 1)
    stop('sum of weight\'s must be 1')
  function(x) {
    s = 0
    for (i in 1:l) {
      if (is.function(baseAlgos[[i]])) {
        s = s + w[i] * baseAlgos[[i]](x)
      } else {
        s = s + w[i] * predict(baseAlgos[[i]], x)
      }
    }
    s
  }
}

gmeanAggregator = function (baseAlgos, w=NULL) {
  l = length(baseAlgos)
  function(x) {
    s = 1
    for (algo in baseAlgos) {
      if (is.function(algo)) {
        s = s * algo(x);
      } else {
        s = s * predict(algo, x);
      }
    }
    s ^ (1/l)
  }
}
