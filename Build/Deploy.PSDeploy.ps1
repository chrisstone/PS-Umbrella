# Generic module deployment.
#
# ASSUMPTIONS:
#
# * folder structure either like:
#
#   - RepoFolder
#     - This PSDeploy file
#     - ModuleName
#       - ModuleName.psd1
#
#   OR the less preferable:
#   - RepoFolder
#     - RepoFolder.psd1
#
# * Nuget key in $ENV:NugetApiKey
#
# * Set-BuildEnvironment from BuildHelpers module has populated ENV:BHModulePath and related variables

# Publish to gallery with a few restrictions
If (
	$env:BHModulePath -and
	$env:BHBuildSystem -ne 'Unknown' -and
	$env:BHBranchName -eq "master"
) {
	Deploy Module {
		By PSGalleryModule {
			FromSource $ENV:BHModulePath
			To PSGallery
			WithOptions @{
				ApiKey = $ENV:NugetApiKey
			}
		}
	}
} else {
	"Skipping deployment: To deploy, ensure that...`n" +
	"`t* You are in a known build system (Current: $ENV:BHBuildSystem)`n" +
	"`t* You are committing to the master branch (Current: $ENV:BHBranchName) `n" +
	"`t* Your commit message includes !deploy (Current: $ENV:BHCommitMessage)" |
		Write-Output
}

# Publish to AppVeyor if we're in AppVeyor
If (
	$env:BHModulePath -and
	$env:BHBuildSystem -eq 'AppVeyor'
) {
	Deploy DeveloperBuild {
		By AppVeyorModule {
			FromSource $ENV:BHModulePath
			To AppVeyor
			WithOptions @{
				Version = $env:APPVEYOR_BUILD_VERSION
			}
		}
	}
}