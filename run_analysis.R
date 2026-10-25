# Extracted from the student-authored Quarto solution; run from repository root.
X <- scan("data/reef_counts_unlabelled.txt", quiet = TRUE)
X0 <- scan("data/reef_counts_labelled.txt", quiet = TRUE)
stopifnot(length(X) == 300, length(X0) == 100)
pdf("em-diagnostics.pdf")
compute.prob.x.z <- function(X, w.curr, lambda_curr) {
  
  prob.x.z <- matrix(
    NA,
    nrow = length(X),
    ncol = length(w.curr)
  )
  
  for (k in seq_len(ncol(prob.x.z))) {
    prob.x.z[, k] <- dpois(X, lambda_curr[k]) * w.curr[k]
  }
  
  return(list(prob.x.z = prob.x.z))
}

compute.log.lik <- function(X, w.curr, lambda_curr) {
  
  prob.x.z <- compute.prob.x.z(X, w.curr, lambda_curr)$prob.x.z
  ill <- sum(log(rowSums(prob.x.z)))
  
  return(list(ill = ill))
}

EM.iter <- function(X, w.curr, lambda_curr) {
  
  # E-step
  prob.x.z <- compute.prob.x.z(X, w.curr, lambda_curr)$prob.x.z
  
  P_ik <- prob.x.z / rowSums(prob.x.z)
  
  # M-step
  w.new <- colSums(P_ik) / sum(P_ik)
  
  lambda_new <- colSums(P_ik * X) / colSums(P_ik)
  
  return(list(w.new = w.new, lambda_new = lambda_new))
}


mixture.EM <- function(X, w.init, lambda_init, epsilon = 1e-5, max.iter = 100) {
  w.curr <- w.init
  lambda_curr <- lambda_init
  
  log_liks <- c()
  log_liks <- c(
    log_liks,
    compute.log.lik(X, w.curr, lambda_curr)$ill
  )
  
  delta.ll <- Inf
  n.iter <- 1
  
  while ((delta.ll > epsilon) & (n.iter <= max.iter)) {
    EM.out <- EM.iter(X, w.curr, lambda_curr)
    
    w.curr <- EM.out$w.new
    lambda_curr <- EM.out$lambda_new
    
    log_liks <- c(
      log_liks,
      compute.log.lik(X, w.curr, lambda_curr)$ill
    )
    
    delta.ll <- abs(log_liks[length(log_liks)] - log_liks[length(log_liks) - 1])
    n.iter <- n.iter + 1
  }
  
  return(list(w.curr = w.curr, lambda_curr = lambda_curr,
              log_liks = log_liks, n.iter = n.iter -1))
}


EM1 <- mixture.EM(X, w.init = c(0.3, 0.3, 0.4), lambda_init = c(3, 20, 35))

EM2 <- mixture.EM(X, w.init = c(0.1, 0.2, 0.7), lambda_init = c(5, 25, 40))


ylim_range <- range(c(EM1$log_liks, EM2$log_liks))

par(mfrow = c(1, 2))
plot(
  0:(length(EM1$log_liks) - 1),
  EM1$log_liks,
  type = "b",
  ylim = ylim_range,
  xlab = "Iteration",
  ylab = "Incomplete log-likelihood",
  main = "Initialisation 1"
)

plot(
  0:(length(EM2$log_liks) - 1),
  EM2$log_liks,
  type = "b",
  ylim = ylim_range,
  xlab = "Iteration",
  ylab = "Incomplete log-likelihood",
  main = "Initialisation 2"
)
par(mfrow = c(1,1))


all(diff(EM1$log_liks) >= -1e-10)
all(diff(EM2$log_liks) >= -1e-10)

EM1$log_liks[length(EM1$log_liks)]
EM2$log_liks[length(EM2$log_liks)]

results <- rbind(
  EM1 = c(
    pi1 = EM1$w.curr[1],
    pi2 = EM1$w.curr[2],
    pi3 = EM1$w.curr[3],
    lambda1 = EM1$lambda_curr[1],
    lambda2 = EM1$lambda_curr[2],
    lambda3 = EM1$lambda_curr[3],
    logLik = EM1$log_liks[length(EM1$log_liks)],
    iterations = EM1$n.iter
  ),
  EM2 = c(
    pi1 = EM2$w.curr[1],
    pi2 = EM2$w.curr[2],
    pi3 = EM2$w.curr[3],
    lambda1 = EM2$lambda_curr[1],
    lambda2 = EM2$lambda_curr[2],
    lambda3 = EM2$lambda_curr[3],
    logLik = EM2$log_liks[length(EM2$log_liks)],
    iterations = EM2$n.iter
  )
)

round(results, 4)



compute.log.lik.2 <- function(X, X0, w.curr, lambda_curr) {
  prob.x.z <- compute.prob.x.z(X, w.curr, lambda_curr)$prob.x.z
  
  ill.unlabelled <- sum(log(rowSums(prob.x.z)))
  ill.labelled <- sum(dpois(X0, lambda_curr[2], log = TRUE))
  
  ill <- ill.unlabelled + ill.labelled
  
  return(list(ill = ill))
}

EM.iter.2 <- function(X, X0, w.curr, lambda_curr) {
  prob.x.z <- compute.prob.x.z(X, w.curr, lambda_curr)$prob.x.z
  
  P_ik <- prob.x.z / rowSums(prob.x.z)
  
  w.new <- colSums(P_ik) / sum(P_ik)
  
  lambda_new <- numeric(3)
  
  lambda_new[1] <- sum(P_ik[, 1] * X) / sum(P_ik[, 1])
  
  lambda_new[2] <- (sum(P_ik[, 2] * X) + sum(X0)) /
    (sum(P_ik[, 2]) + length(X0))
  
  lambda_new[3] <- sum(P_ik[, 3] * X) / sum(P_ik[, 3])
  
  return(list(w.new = w.new, lambda_new = lambda_new))
}


mixture.EM.2 <- function(X, X0, w.init, lambda_init, epsilon = 1e-5, max.iter = 100) {
  w.curr <- w.init
  lambda_curr <- lambda_init
  
  log_liks <- c()
  
  log_liks <- c(log_liks, compute.log.lik.2(X, X0, w.curr, lambda_curr)$ill)
  
  delta.ll <- Inf
  n.iter <- 0
  
  while ((delta.ll > epsilon) & (n.iter < max.iter)) {
    EM.out <- EM.iter.2(X, X0, w.curr, lambda_curr)
    
    w.curr <- EM.out$w.new
    lambda_curr <- EM.out$lambda_new
    
    log_liks <- c(log_liks, compute.log.lik.2(X, X0, w.curr, lambda_curr)$ill)
    
    delta.ll <- abs(log_liks[length(log_liks)] -
                      log_liks[length(log_liks) - 1])
    
    n.iter <- n.iter + 1
  }
    
  return(list(w.curr = w.curr, lambda_curr = lambda_curr,
                log_liks = log_liks, n.iter = n.iter))
}


EM1.2 <- mixture.EM.2(X, X0, w.init = c(0.3, 0.3, 0.4),
                      lambda_init = c(3, 20, 35))

EM2.2 <- mixture.EM.2(X, X0, w.init = c(0.1, 0.2, 0.7),
                      lambda_init = c(5, 25, 40))



ylim_range <- range(c(EM1.2$log_liks, EM2.2$log_liks))

par(mfrow = c(1,2))

plot(
  0:(length(EM1.2$log_liks) - 1),
  EM1.2$log_liks,
  type = "b",
  ylim = ylim_range,
  xlab = "Iteration",
  ylab = "Incomplete log-likelihood",
  main = "Initialisation 1"
)

plot(
  0:(length(EM2.2$log_liks) - 1),
  EM2.2$log_liks,
  type = "b",
  ylim = ylim_range,
  xlab = "Iteration",
  ylab = "Incomplete log-likelihood",
  main = "Initialisation 2"
)
par(mfrow = c(1,1))


all(diff(EM1.2$log_liks) >= -1e-10)
all(diff(EM2.2$log_liks) >= -1e-10)

EM1.2$log_liks[length(EM1.2$log_liks)]
EM2.2$log_liks[length(EM2.2$log_liks)]

results.2 <- rbind(
  EM1 = c(
    pi1 = EM1.2$w.curr[1],
    pi2 = EM1.2$w.curr[2],
    pi3 = EM1.2$w.curr[3],
    lambda1 = EM1.2$lambda_curr[1],
    lambda2 = EM1.2$lambda_curr[2],
    lambda3 = EM1.2$lambda_curr[3],
    logLik = EM1.2$log_liks[length(EM1.2$log_liks)],
    iterations = EM1.2$n.iter
  ),
  EM2 = c(
    pi1 = EM2.2$w.curr[1],
    pi2 = EM2.2$w.curr[2],
    pi3 = EM2.2$w.curr[3],
    lambda1 = EM2.2$lambda_curr[1],
    lambda2 = EM2.2$lambda_curr[2],
    lambda3 = EM2.2$lambda_curr[3],
    logLik = EM2.2$log_liks[length(EM2.2$log_liks)],
    iterations = EM2.2$n.iter
  )
)

round(results.2, 4)

dev.off()
