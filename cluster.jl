include("./Gravity.jl")

plotly()

cluster = System("Star Cluster")

n = 10^2
d = 10^4
mass = 10^2

for i in 1:n
	b = Body("Star $(i)", d*rand(3), d*rand(-1:0.01:1, 3), mass*rand())
	add_body(cluster, b)
end

bh = Body("Blackhole", [0.5d, 0.5d, 0.5d], [0.0, 0.0, 0.0], 10^10)

add_body(cluster, bh)

plotargs = Dict(:title => cluster.name,
				:legend => false,
				:xlim => (-0.5*d, 1.5*d),
				:ylim => (-0.5*d, 1.5*d),
				:zlim => (-0.5*d, 1.5*d),
				:aspect_ratio => :equal)

end_time =  50
time_step = 0.01

@time orbit = calculate_orbits(cluster, 0:time_step:end_time, verbose = true)
@time plot_orbits(orbit, dim = 3, plotargs = plotargs, verbose = true)
