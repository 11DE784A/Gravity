using LinearAlgebra
using Plots

G = 4π^2 # Astronomical units, solar masses, years

mutable struct Body
	name
	pos
	vel
	mass::Float64
	system

	function Body(name, pos, vel, mass, system = nothing)
		new(name, pos, vel, mass, system)
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

function add_body(s::System, b::Body)
	if b.system == s
		@warn("$(b) already in $(s). Skipping")
	elseif b.system != nothing
		@warn("$(b)'s system was overwritten")
	end

	b.system = s
	push!(s.bodies, b)
end

function add_bodies(s::System, body_list)
	for b in body_list
		add_body(s, b)
	end
end

function calculate_orbits(s::System, t, verbose = false)
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
			b = s.bodies[j]

			b.vel += 0.5 * (force(b)/b.mass) * dt
			b.pos += b.vel * dt
			b.vel += 0.5 * (force(b)/b.mass) * dt
			
			orbits[j][i, :] = b.pos
		end

		if verbose
			println("Finished calculating positions at time step $(i-1) of $(length(t)-1).")
		end
	end

	if verbose println("Orbits calculated.") end

	orbits
end

# Helper function. Plots orbits
function plot_orbits(orbits, dim = 2)
	p = plot(title = "")
	for orbit in orbits
		o = [orbit[:, i] for i in 1:dim]
		p = plot!(o..., line = :dot, linewidth = 4)
	end
	p
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
