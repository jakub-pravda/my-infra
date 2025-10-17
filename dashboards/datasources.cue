package config

#metadata: {
	name: string
}

#datasource: {
	kind:     "GlobalDatasource"
	metadata: #metadata
	spec:     #dataSourceSpec
}

#dataSourceSpec: {
	default: bool
	plugin:  #dataSourcePlugin
}

#dataSourcePlugin: #dataSourcePromPlugin

#dataSourcePromPlugin: {
	kind: "PrometheusDatasource"
	spec: {
		directUrl: string
	}
}

// Datasource definition
#datasource & {
	metadata: #metadata & {
		name: "prometheus-local"
	}
	spec: #dataSourceSpec & {
		default: true
		plugin: #dataSourcePromPlugin & {
			spec: {
				directUrl: "http://localhost:9090"
			}
		}
	}
}
