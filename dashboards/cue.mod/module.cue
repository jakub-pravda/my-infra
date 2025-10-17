module: "cue.example"
language: {
	version: "v0.14.1"
}
deps: {
	"github.com/perses/perses/cue@v0": {
		v:       "v0.52.0"
		default: true
	}
	"github.com/perses/plugins/prometheus@v0": {
		v:       "v0.53.4"
		default: true
	}
	"github.com/perses/plugins/timeserieschart@v0": {
		v:       "v0.10.2"
		default: true
	}
}
