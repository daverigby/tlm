properties([pipelineTriggers([gerrit(customUrl: '',
                                     gerritProjects: [[branches: [[compareType: 'PLAIN',
                                                                   pattern: env.BRANCH_NAME]],
                                                       compareType: 'PLAIN',
                                                       disableStrictForbiddenFileVerification: false,
                                                       pattern: 'ep-engine']],
                                     triggerOnEvents: [patchsetCreated(excludeDrafts: true,
                                                                       excludeNoCodeChange: false,
                                                                       excludeTrivialRebase: false)])])])

node {
    // Checkout the manifest
    stage('Manifest') {
        checkout([$class: 'RepoScm',
                  currentBranch: true,
                  jobs: 8,
                  manifestFile: 'watson.xml',
                  manifestGroup: 'build,kv',
                  manifestRepositoryUrl: 'https://github.com/couchbase/manifest',
                  quiet: true,
                  resetFirst: true])
    }

    // Checkout the code from gerrit
    stage('Gerrit') {
        sh "cbbuild/scripts/jenkins/commit_validation/checkout_dependencies.py $GERRIT_PATCHSET_REVISION $GERRIT_CHANGE_ID $GERRIT_PROJECT $GERRIT_REFSPEC"
    }

    stage('Configure') {
        env.PATH = "${env.PATH}:/usr/local/bin"
        sh "mkdir -p build"
        dir ('build') {
            sh "cmake -DCOUCHBASE_KV_COMMIT_VALIDATION=1 .."
        }
    }

    stage('Compile') {
        dir ('build') {
            sh "make -j4"
        }
    }

    stage('Test') {
        dir ('build/ep-engine') {
            sh "ctest -j4 -T Test --output-on-failure -R hash"
        }
        step([$class: 'XUnitBuilder',
              testTimeMargin: '3000',
              thresholdMode: 1,
              thresholds: [[$class: 'FailedThreshold', failureNewThreshold: '', failureThreshold: '0', unstableNewThreshold: '', unstableThreshold: ''],
                           [$class: 'SkippedThreshold', failureNewThreshold: '', failureThreshold: '', unstableNewThreshold: '', unstableThreshold: '']],
              tools: [[$class: 'CTestType',
                       deleteOutputFiles: true,
                       failIfNotNew: true,
                       pattern: '**/Testing/**/Test.xml',
                       skipNoTestFiles: false,
                       stopProcessingIfError: true]]])
    }
}
