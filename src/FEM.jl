module FEM

using Compat

macro lintpragma(s) end

export Node, NodeSet, ElementSet, GaussPoint, DirichletBC, PointLoad, Du, Dv, Dw, Dof
export Element, LinTrig
export Interpolator, LinTrigInterp
export Material, LinearIsotropic
export Mesh, addnode!, addelem!, addelemset!, addnodeset!, addnodes!
export FEProblem

include("core.jl")
include("materials/material.jl")
include("interpolators/interpolator.jl")
include("elements/element.jl")
include("mesh.jl")
include("fe_problem.jl")



end
