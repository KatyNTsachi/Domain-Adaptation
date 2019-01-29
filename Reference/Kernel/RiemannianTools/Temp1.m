close all
clear

%%
D = 5;
P1 = randn(D);
P1 = P1 * P1';

P2 = randn(D);
P2 = P2 * P2';

%%
S1 = LogMap(P2, P1);

DR = RiemannianDist(P1, P2)
D2 = norm(P2^-(1/2) * S1 * P2^-(1/2), 'fro')
