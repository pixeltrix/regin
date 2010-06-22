require 'regin'
require 'benchmark'

TIMES = 10_000.to_i

Benchmark.bmbm do |x|
  x.report('foo')               { TIMES.times { Regin.parse(/foo/) } }
  x.report('foo(/bar)?')        { TIMES.times { Regin.parse(/foo(\/bar)?/) } }
  x.report('foo(/bar(/baz)?)?') { TIMES.times { Regin.parse(/foo(\/bar(\/baz)?)?/) } }
end

#                         user     system      total        real
# foo                 0.820000   0.010000   0.830000 (  0.832653)
# foo(/bar)?          2.150000   0.020000   2.170000 (  2.175744)
# foo(/bar(/baz)?)?   3.450000   0.030000   3.480000 (  3.478671)
