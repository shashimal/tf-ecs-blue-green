'use strict';

const AWS = require('aws-sdk');
const codedeploy = new AWS.CodeDeploy({apiVersion: '2014-10-06'});

exports.handler = (event, context, callback) => {

    console.log("Entering AfterAllowTestTraffic hook.");

    const deploymentId = event.DeploymentId;
    const lifecycleEventHookExecutionId = event.LifecycleEventHookExecutionId;
    let validationTestResult = "Failed";

    console.log("This is where AfterAllowTestTraffic validation tests happen.")
    validationTestResult = "Succeeded";

    // Complete the AfterAllowTestTraffic hook by sending CodeDeploy the validation status
    const params = {
        deploymentId: deploymentId,
        lifecycleEventHookExecutionId: lifecycleEventHookExecutionId,
        status: validationTestResult // status can be 'Succeeded' or 'Failed'
    };

    // Pass CodeDeploy the prepared validation test results.
    codedeploy.putLifecycleEventHookExecutionStatus(params, function(err, data) {
        if (err) {
            // Validation failed.
            console.log('AfterAllowTestTraffic validation tests failed');
            console.log(err, err.stack);
            callback("CodeDeploy Status update failed");
        } else {
            // Validation succeeded.
            console.log("AfterAllowTestTraffic validation tests succeeded");
            callback(null, "AfterAllowTestTraffic validation tests succeeded");
        }
    });
}