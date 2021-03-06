import jobLib.rhsmLib

String desc = "Run 'make stylish' on github pull requests for subscription-manager.\n\n" +
              "This runs against pull request branches."

def stylishJob = job("subscription-manager-stylish-tests-pr"){
    description(desc)
    label('rhsm')
    wrappers {
        preBuildCleanup()
        colorizeOutput('css')
    }
    logRotator{
        numToKeep(20)
    }
    steps {
        shell readFileFromWorkspace('resources/subscription-manager-stylish-tests.sh')
    }
    publishers {
        archiveArtifacts {
            pattern('stylish_results.txt')
        }
    }
}

rhsmLib.addPullRequester(stylishJob, rhsmLib.submanRepo, 'jenkins-stylish')
rhsmLib.addCandlepinNotifier(stylishJob)