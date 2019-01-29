function X1 = SchildLadder(A0, A1, X0)

P  = ExpMap(X0, 1/2 * LogMap(X0, A1));
X1 = ExpMap(A0, 2   * LogMap(A0, P));

end