package Agentai;

import jade.core.Agent;
import jade.core.behaviours.TickerBehaviour;
import jade.core.behaviours.WakerBehaviour;

// Arguments:   -name Platforma -gui SP_Agentas:Agentai.Sav_4(3000,Hello,3000)
//              -name Platforma -gui SP_Agentas:Agentai.Sav_4(Hello,3000)
public class Sav_4 extends Agent{
    @Override
    protected void setup(){
        Object[] args = getArguments();
        int time = 5000;
        String message;
        int turnOffAfter;
        if(args.length == 3){
            time = Integer.parseInt(args[0].toString());
            message = args[1].toString();
            turnOffAfter = Integer.parseInt(args[2].toString());
        }
        else{
            message = args[0].toString();
            turnOffAfter = Integer.parseInt(args[1].toString());
        }
        
        addBehaviour(new TickerBehaviour(this, 1000){
            @Override
            protected void onTick(){
                System.out.println("Current time: " + getTickCount() + " s.");
            }
        });
        
        addBehaviour(new WakerBehaviour(this, time) {
            @Override
            protected void onWake(){
                System.out.println(message);
                myAgent.addBehaviour(new WakerBehaviour(myAgent, turnOffAfter) {
                    @Override
                    protected void onWake(){
                        doDelete();
                    }
                });
            }
        });
    }
}