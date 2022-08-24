

Document API_Coverage {
	Section 'API Coverage' {
		'This page is intended to document the progress of the API implementation in this Module'
	}

	$APICoverage = @'
	GET, Organization, Implemented
'@ | ConvertFrom-Csv

	$APICoverage | Table
}
