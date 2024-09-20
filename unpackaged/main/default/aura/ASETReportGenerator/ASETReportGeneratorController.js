({
    doInit : function(component, event, helper) {
        
        var action = component.get("c.generatePDF");
        action.setParams({"recordId": component.get('v.recordId')});
        
        action.setCallback(this, function (response) { 
            var state = response.getState();
            if (state === 'SUCCESS') {
                var result = response.getReturnValue();
                // Code when Success
                window.open('/apex/ASETPathologyReport?id='+component.get('v.recordId'));
                window.setTimeout(
                    $A.getCallback(function() {
                        $A.get('e.force:refreshView').fire();
                        $A.get("e.force:closeQuickAction").fire();
                    }), 2000
                );
            } else if (state === 'INCOMPLETE') {
                // Code when Imcomplete
            } else if (state === 'ERROR') {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                        console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
                
    },
    
    
    
    
    
    
})