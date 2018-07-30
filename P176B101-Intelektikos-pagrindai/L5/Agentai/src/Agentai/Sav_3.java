package Agentai;

import jade.core.Agent;
import jade.core.behaviours.TickerBehaviour;
import jade.core.behaviours.WakerBehaviour;

// Arguments: -name Platforma -gui SP_Agentas:Agentai.Sav_3(3000,Hello,3000)
public class Sav_3 extends Agent{
    @Override
    protected void setup(){
        Object[] args = getArguments();
        int time = Integer.parseInt(args[0].toString());
        String message = args[1].toString();
        int turnOffAfter = Integer.parseInt(args[2].toString());
        
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