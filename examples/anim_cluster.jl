include("../code/Gravity.jl")

using .Gravity

cluster = System("Star Cluster: 100 Bodies")

n = 10^2
d = 10^4
dim = 3
mass = 10^2

for i in 1:n
	b = Body("Star $(i)", d*rand(dim), d*rand(-1:0.01:1, dim), mass*rand())
	add_body!(cluster, b)
end

bh = Body("Blackhole", 0.5d*ones(dim), zeros(dim), 10^10)
add_body!(cluster, bh)

plotargs = Dict(:size => (500, 500),
				:title => cluster.name,
				:legend => false,
				:xlim => (-0.2*d, 1.2*d),
				:xlabel => "x (A. U.)",
				:ylim => (-0.2*d, 1.2*d),
				:ylabel => "y (A. U.)",
				:zlim => (-0.2*d, 1.2*d),
				:zlabel => "z (A. U.)",
				:aspect_ratio => :equal)

end_time =  50
time_step = 0.01

@time orbits = calculate_orbits(cluster, 0:time_step:end_time, verbose = true)
@time anim = animate_orbits(orbits, dim = dim, every = 2, plotargs = plotargs, verbose = true);
