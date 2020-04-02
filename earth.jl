include("Gravity.jl")

using .Gravity

solar = System("Sun-Earth-Moon")

earth = Body("Earth", [1, 0], [0, 2π], 3*10^-6)
moon = Body("Moon", [1.00257, 0], [0, 2*1.0313π], 0.0123*earth.mass)
sun = Body("Sun", [0, 0], [0, 0], 1)

add_bodies!(solar, [sun, moon, earth])
orbit = calculate_orbits(solar, 0:0.0001:1, verbose = true)

plotargs = Dict(:title => solar.name,
				:legend => false,
				:xlim => (-1.5, 1.5),
				:xlabel => "x (A. U.)",
				:ylim => (-1.5, 1.5),
				:ylabel => "y (A. U.)",
				:aspect_ratio => :equal)

plot_orbits(orbit, dim = 2, plotargs = plotargs, verbose = true)
