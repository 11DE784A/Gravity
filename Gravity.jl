module Gravity

using LinearAlgebra
using Plots

export Body, System, add_body!, add_bodies!, calculate_orbits, plot_orbits, animate_orbits

const G = 4π^2 # Astronomical units, solar masses, years

mutable struct Body
	name
	pos
	vel
	mass
	system

	function Body(name, pos, vel, mass)
		new(name, pos, vel, mass, nothing)
	end
end

mutable struct System
	name
	bodies
	time_elapsed

	function System(name, bodies = [])
		new(name, bodies, 0)
	end
end


"""
Methods for type System
"""

function Base.show(io::IO, s::System)
	print(io, "System '$(s.name)'")
end

function size(s::System)
	length(s.bodies)
end

function add_body!(s::System, b::Body)
	if b.system == s
		@warn("$(b) already in $(s). Skipping")
	elseif b.system != nothing
		@warn("$(b)'s system was overwritten")
	end

	b.system = s
	push!(s.bodies, b)
end

function add_bodies!(s::System, body_list)
	for b in body_list
		add_body!(s, b)
	end
end

function calculate_orbits(s::System, t; verbose = false)
	orbits = []

	if verbose println("Initializing orbits array...") end

	for body in s.bodies
		orbit = zeros(length(t), length(body.pos))
		orbit[1, :] = body.pos
		push!(orbits, orbit)
	end

	if verbose println("Calculating orbits...") end

	for i in 2:length(t)
		for j in 1:size(s)
			dt = t[i] - t[i-1]
			s.time_elapsed += dt

			b = s.bodies[j]

			b.vel += 0.5 * (force(b)/b.mass) * dt
			b.pos += b.vel * dt
			b.vel += 0.5 * (force(b)/b.mass) * dt
			
			orbits[j][i, :] = b.pos
		end

		if verbose
			print("\e[2K\e[1G")
			print("Finished calculating positions at time step $(i-1) of $(length(t)-1).")
		end
	end

	if verbose println("\nOrbits calculated.") end

	orbits
end

# Helper function. Plots orbits
function plot_orbits(orbits; dim = 2, plotargs = Dict(), verbose = false)
	p = plot(;plotargs...)

	if verbose println("Plotting orbits...") end

	for i in 1:length(orbits)
		o = [orbits[i][:, j] for j in 1:dim]
		p = plot!(o...)

		if verbose
			print("\e[2K\e[1G")
			print("Finished plotting orbit $(i) of $(length(orbits)).")
		end
	end

	if verbose println("\nDone plotting orbits.") end
	p
end

function animate_orbits(orbits; dim = 2, every = 1, plotargs = Dict(), verbose = false)
	anim = Animation()

	p = scatter(;plotargs...)
	n = Base.size(orbits[1])[1]

	if verbose println("Rendering animation...") end

	for j in 1:every:n
		pos = [[[orbits[i][j, k]] for i in 1:length(orbits)] for k in 1:dim]
		p = scatter(pos...; plotargs...)
		frame(anim)

		if verbose
			print("\e[2K\e[1G")
			print("Finished rendering frame $(j) of $(n).")
		end
	end

	if verbose println("\nDone creating animation object.") end
	anim
end


"""
Methods for type Body
"""

function Base.show(io::IO, b::Body)
	print(io, "$(b.name)")
end

function force(b::Body)
	net_force = zeros(length(b.pos))
	for body in b.system.bodies
		if body == b continue end
		d = body.pos - b.pos
		net_force += (G * b.mass*body.mass * d) / norm(d)^3
	end

	net_force
end

end
