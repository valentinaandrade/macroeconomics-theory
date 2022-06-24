function KRes2 = KRes2(K,alpha,delta,A,Res)

KRes2 = A.*(K.^alpha) + (1-delta).*K - Res;