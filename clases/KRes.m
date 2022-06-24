function KRes = KRes(K,alpha,delta,Res)

KRes = K.^alpha + (1-delta).*K - Res;