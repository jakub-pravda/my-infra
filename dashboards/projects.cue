package config

#display: {
	name:        string
	description: string
}

#metadata: {
	name: string
}

#project: {
	kind:     "Project"
	metadata: #metadata
	spec: {
		display: #display
	}
}

// Project definition
#project & {
	metadata: name: "BasicMonitoring"
	spec: display: name:        "BasicMonitoring"
	spec: display: description: "Basic monitoring dashboard"
}
