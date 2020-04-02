# Gravity
A prototype library for n-body simulations. Written in Julia.

----

### Usage Instructions

First, the `Gravity.jl` file needs to be included and the module imported.

```julia
julia> include("Gravity.jl")
julia> using .Gravity
```

The module provides `Body` for creating bodies (stars, planets, blackholes).
At instantiation, bodies need a position, a velocity, and a mass. Natural
units for the simulation are astronomical units, years, and solar masses.

```julia
julia> earth = Body("Earth", # A name for the body
                    [1, 0],  # Position
                    [0, 2π], # Velocity
                    3*10^-6) # Mass
julia> sun = Body("Sun", [0, 0], [0, 0], 1)
```

For a three dimensional simulation, the positions and velocities in `Body`
definitions should be three dimensional.

In order to run the simulation, the bodies need to be added to a `System`.

```julia
julia> sol = System("Solar System")
julia> add_bodies!(sol, [sun, earth])
```

We can now calculate the orbits. In its arguments, `calculate_orbits` needs the
system (`sol`) and a discretized domain for the integration of the equations of
motion.


```julia
julia> time_step = 0.001
julia> total_time = 1
julia> orbits = calculate_orbits(solar, # System
                                 0:time_step:total_time, # Time domain
                                 verbose = true) # This will print status messages
```

#### Plotting and Animating

Plotting and animations are done using
[Plots.jl](http://docs.juliaplots.org/latest/). Options for `plot` (provided by
Plots.jl) can be specified into a dictionary

```julia
plotargs = Dict(:title => Solar System,
                :xlim => (-1.5, 1.5),
                :xlabel => "x (AU)",
                :ylim => (-1.5, 1.5),
                :ylabel => "y (AU)",
                :aspect_ratio => :equal)
```

and the orbits plotted with `plot_orbits`.

```julia
plot_orbits(orbits, # the array obtained from `calculate_orbits`
            plotargs = plotargs, # arguments for `plot`
            verbose = true) # for status messages
```

For three dimensional plots, `dim = 3` needs to be passed to `plot_orbits`.

```julia
plot_orbits(orbits, dim = 3, plotargs = plotargs, verbose = true)
```

Animations can be created with `animate_orbits`.

```julia
anim = animate_orbits(orbits,
                      dim = 3,    # for 3D plots
                      every = 30, # save a frame "every N iterations"
                      plotargs = plotargs,
                      verbose = true)
```
