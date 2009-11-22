require 'reginald'
require 'benchmark'

TIMES = 10_000.to_i

Benchmark.bmbm do |x|
  x.report('foo')               { TIMES.times { Reginald.parse(/foo/) } }
  x.report('foo(/bar)?')        { TIMES.times { Reginald.parse(/foo(\/bar)?/) } }
  x.report('foo(/bar(/baz)?)?') { TIMES.times { Reginald.parse(/foo(\/bar(\/baz)?)?/) } }
end
