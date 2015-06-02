#ε  = [-0.0012666666668330606,-7.349676423018536e-14,0.0,0.007158333333453266,0.0,0.0,0.0,0.007158333333453266,0.0]
using FEM

E = 200000.e0
nu = 0.3e0
n = 1.e0
l = 1.e-2
Hg = 4.e7
Hl = 10_000.01
m = 2.0
sy = 1000.0
tstar = 1000.0
angles = [45.0, 105.0]
nslip = 2

mat = FEM.gradmekhmodjlsmall().GradMekh(E, nu, n, l,
               Hg, Hl, m, sy, tstar,
               angles, nslip)

matstat = FEM.GradMekhModJlSmall.GradMekhMS([0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0],[0.0,0.0],[0.0,0.0],[-1.6642243139131097e-13,-7.346516920222348e-14,0.0,0.01300000000023993,0.0,0.0],[-5.328643509345126e-8,-3.899017860712424e-8,-2.768298411017265e-8,1000.0000000184538,0.0,0.0])
temp_matstat = copy(matstat)

κ_nl = [0.0,0.0]
F1  = [0.9987333333331669 0.014316666666833067 0.0
 7.346516920222372e-14 0.9999999999999265 0.0
 0.0 0.0 1.0]

FEM.stress(mat, matstat, temp_matstat, κ_nl, F1)



#J [1000.0 0.0
# 377.5804903684635 -417.3957871553974]
