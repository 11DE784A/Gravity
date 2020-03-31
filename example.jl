include("./gravity.jl")

solar = System("Sun-Earth-Moon")

earth = Body("Earth", [1, 0], [0, 2π], 3*10^-6)
moon = Body("Moon", [1.00257, 0], [0, 2*1.0313π], 0.0123*earth.mass)
sun = Body("Sun", [0, 0], [0, 0], 1)

add_bodies(solar, [sun, earth, moon])
orbit = calculate_orbits(solar, 0:0.001:1, true)
gui(plot_orbits(orbit))
