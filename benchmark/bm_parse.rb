require 'reginald'
require 'benchmark'

TIMES = 10_000.to_i

Benchmark.bmbm do |x|
  x.report('foo')               { TIMES.times { Reginald.parse(/foo/) } }
  x.report('foo(/bar)?')        { TIMES.times { Reginald.parse(/foo(\/bar)?/) } }
  x.report('foo(/bar(/baz)?)?') { TIMES.times { Reginald.parse(/foo(\/bar(\/baz)?)?/) } }
end

#                         user     system      total        real
# foo                 1.360000   0.020000   1.380000 (  1.375510)
# foo(/bar)?          3.560000   0.050000   3.610000 (  3.616319)
# foo(/bar(/baz)?)?   5.780000   0.090000   5.870000 (  5.866146)
