package dashboards

import (
	dashboardBuilder "github.com/perses/perses/cue/dac-utils/dashboard"
	panelGroupsBuilder "github.com/perses/perses/cue/dac-utils/panelgroups"
	//varGroupBuilder "github.com/perses/perses/cue/dac-utils/variable/group"
	//textVarBuilder "github.com/perses/perses/cue/dac-utils/variable/text"
	panelBuilder "github.com/perses/plugins/prometheus/sdk/cue/panel"
	//promQLVarBuilder "github.com/perses/plugins/prometheus/sdk/cue/variable/promql"
	//promFilterBuilder "github.com/perses/plugins/prometheus/sdk/cue/filter"
	timeseriesChart "github.com/perses/plugins/timeserieschart/schemas:model"
	promQuery "github.com/perses/plugins/prometheus/schemas/prometheus-time-series-query:model"
)

dashboardBuilder & {
	#name:    "ServerMonitoring"
	#project: "BasicMonitoring"

	// #variables: {varGroupBuilder & {
	//     #input: [
	//         textVarBuilder & {
	//             #name:     "prometheus"
	//             #value:    "platform"
	//             #constant: true
	//         },
	//         labelValuesVarBuilder & {
	//             #name: "stack"
	//             #display: name: "PaaS"
	//             #metric:         "thanos_build_info"
	//             #label:          "stack"
	//             #datasourceName: "localprom"
	//         }
	//     ]
	// }}.variables
	#panelGroups: panelGroupsBuilder & {
		#input: [
			{
				#title: "Server Monitoring"
				#cols:  3
				#panels: [
					panelBuilder & {
						spec: {
							display: name: "CPU"
							plugin: timeseriesChart
							queries: [
								{
									kind: "TimeSeriesQuery"
									spec: plugin: promQuery & {
										spec: {
											query: """
                                                (avg without (mode,cpu) (
                                                1 - rate(node_cpu_seconds_total{mode="idle"}[1m])
                                                )) * 100
                                            """
											datasource: name: "prometheus-local"
										}
									}
								},
							]
						}
					},
				]
			},
		]
	}
}
