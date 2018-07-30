package Agentai;

import jade.core.Agent;
import jade.core.behaviours.OneShotBehaviour;
import jade.core.behaviours.TickerBehaviour;
import jade.core.behaviours.WakerBehaviour;
import jade.core.behaviours.CyclicBehaviour;

// Arguments: -name Platforma -gui PAG_Agentas:Agentai.Sveikas_Pasauli
public class Sveikas_Pasauli extends Agent {
    private int countdown = 10;
    private boolean start = false;
    private boolean stopAgent = false;
    @Override
    protected void setup(){
        addBehaviour(new OneShotBehaviour(this) {
            @Override
            public void action() {
                System.out.println("Sveikas_Pasauli");
                System.out.println("Mano vardas yra - " + getAID().getLocalName());
            }
        });
        addBehaviour(new TickerBehaviour(this, 1000) {
            @Override
            protected void onTick() {
                if (start){
                    System.out.println(countdown + " sek");
                    if (countdown == 0){
                        stopAgent = true;
                    }
                    else{
                        countdown--;
                    }
                }
            }
        });
        addBehaviour(new WakerBehaviour(this, 3000) {
            @Override
            protected void onWake(){
                start = true;
            }
        });
        addBehaviour(new CyclicBehaviour(this) {
            @Override
            public void action(){
                if(stopAgent){
                    doDelete();
                }
            }
        });
    }
}
