include("../code/Gravity.jl")

using .Gravity

sol = System("Sun Earth System")

earth = Body("Earth", [1, 0], [0, 2π], 3*10^-6)
moon = Body("Moon", [1.00257, 0], [0, 2*1.0313π], 0.0123*earth.mass)
sun = Body("Sun", [0, 0], [0, 0], 1)

add_bodies!(sol, [sun, earth])
orbits = calculate_orbits(sol, 0:0.0001:2, verbose = true)

plotargs = Dict(:title => sol.name,
				:size => (500, 500),
				:xlim => (-1.5, 1.5),
				:xlabel => "x (A. U.)",
				:ylim => (-1.5, 1.5),
				:ylabel => "y (A. U.)",
				:aspect_ratio => :equal)

anim = animate_orbits(orbits, name_list(sol),
					  every = 100, plotargs = plotargs, verbose = true);
