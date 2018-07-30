package Agentai;

import jade.core.Agent;
import jade.core.behaviours.TickerBehaviour;
import jade.core.behaviours.WakerBehaviour;

// Arguments: -name Platforma -gui SP_Agentas:Agentai.Sav_2(3000)
public class Sav_2 extends Agent{
    @Override
    protected void setup(){
        Object[] args = getArguments();
        int time = Integer.parseInt(args[0].toString());
        
        addBehaviour(new TickerBehaviour(this, 1000){
            @Override
            protected void onTick(){
                System.out.println("Current time: " + getTickCount() + " s.");
            }
        });
        
        addBehaviour(new WakerBehaviour(this, time) {
            @Override
            protected void onWake(){
                System.out.println("Sveiki aš agentas vardu: " + getAID().getLocalName());
                myAgent.addBehaviour(new WakerBehaviour(myAgent, 30000) {
                    @Override
                    protected void onWake(){
                        doDelete();
                    }
                });
            }
        });
    }
}