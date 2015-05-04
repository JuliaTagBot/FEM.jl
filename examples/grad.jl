using FEM

n_ele = 8

m = [[0.0; 0.0] [0.0; 10.0] [10.0; 10.0] [10.0; 0.0]]
geomesh = meshquad(n_ele, n_ele, m, GeoQTrig)

using FEM
import FEM.write_data
# Nodes


boundary_set = gennodeset(n->n.coords[2]>9.9999, "boundary", geomesh.nodes)
append!(boundary_set, gennodeset(n->n.coords[1]>9.9999, "boundary", geomesh.nodes))
append!(boundary_set, gennodeset(n->n.coords[2]<0.0001, "boundary", geomesh.nodes))
append!(boundary_set, gennodeset(n->n.coords[1]<0.0001, "boundary", geomesh.nodes))

push!(geomesh, boundary_set)
push!(geomesh, ElementSet("all", collect(1:length(geomesh.elements))))
# Material section


E = 200000.e0
nu = 0.3e0
n = 1.e0
l = 1.e-2
kinf = 1e+010
lambda_0 = 4.e-2
Hg = 4.e7
Hl = 10_000.0
m = 2.0
faktor = 1
sy = 1000.0
tstar = 1000.0
c_dam = 1.0
angles = [45.0, 105.0]
nslip = 2

mat = GradMekh(E, nu, n, l, kinf, lambda_0,
               Hg, Hl, m, faktor, sy, tstar,
               c_dam, angles, nslip)

#mat = LinearIsotropic(E, nu)

mat_section = MaterialSection(mat)
push!(mat_section, geomesh.element_sets["all"])

# Element section
ele_section = ElementSection(GradTrig)
push!(ele_section, geomesh.element_sets["all"])

# Boundary conditions
γ = 0.0125
bcs = [DirichletBC("$(γ)*y*t", [FEM.Du], geomesh.node_sets["boundary"]),
       DirichletBC("0.0", [FEM.Dv], geomesh.node_sets["boundary"])]

fp = FEM.create_feproblem_grad("grad_sq_big", geomesh, [ele_section], [mat_section], bcs)


vtkexp = VTKExporter()
set_binary!(vtkexp, false)
push!(vtkexp, Stress)
push!(vtkexp, Strain)
push!(vtkexp, VonMises)
push!(vtkexp, InvFp)
push!(vtkexp, KAlpha)


solver = NRSolver(1e-4, 20)

solve(solver, fp, vtkexp)
