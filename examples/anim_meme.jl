include("../code/Gravity.jl")

using .Gravity

meme = System("Sun-Earth-Moon")

qm = Body("Quantum Mechanics", zeros(2), zeros(2), 1)
people = Body("People", [2.0, 0], [0, π], 10^-6)
math = Body("Math", [-15, -15], [0.5, 1], 1)

add_bodies!(meme, [qm, people, math])
orbit = calculate_orbits(meme, 0:0.0001:15, verbose = true)

plotargs = Dict(:size => (500, 500),
				:xlim => (-15, 15),
				:xlabel => "x (A. U.)",
				:ylim => (-15, 15),
				:ylabel => "y (A. U.)",
				:aspect_ratio => :equal)

anim = animate_orbits(orbit, name_list(meme), every = 500,
					  dim = 2, plotargs = plotargs, verbose = true)
