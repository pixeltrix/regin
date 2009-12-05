require 'reginald'
require 'benchmark'

TIMES = 10_000.to_i

Benchmark.bmbm do |x|
  x.report('foo')               { TIMES.times { Reginald.parse(/foo/) } }
  x.report('foo(/bar)?')        { TIMES.times { Reginald.parse(/foo(\/bar)?/) } }
  x.report('foo(/bar(/baz)?)?') { TIMES.times { Reginald.parse(/foo(\/bar(\/baz)?)?/) } }
end

#                         user     system      total        real
# foo                 1.420000   0.020000   1.440000 (  1.440483)
# foo(/bar)?          3.790000   0.050000   3.840000 (  3.839614)
# foo(/bar(/baz)?)?   6.190000   0.070000   6.260000 (  6.262343)
