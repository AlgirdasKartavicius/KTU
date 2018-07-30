package Agentai;
import jade.core.Agent;
import jade.core.behaviours.CyclicBehaviour;
import jade.core.behaviours.TickerBehaviour;
import jade.core.behaviours.WakerBehaviour;

// Arguments: -name Platforma -gui SP_Agentas:Agentai.Sav_1(Hello)
public class Sav_1 extends Agent{
    private boolean stopAgent = false;
    private int counter = 0;
    @Override
    protected void setup(){
        Object[] args = getArguments();
        String message = args[0].toString();
        
       
//------------------------------------------------------
// Variantas 1
//------------------------------------------------------
//        addBehaviour(new TickerBehaviour(this, 1000){
//            @Override
//            protected void onTick(){
//                System.out.println("Current time: " + getTickCount() + " s.");
//            }
//        });
//         
//        addBehaviour(new TickerBehaviour(this, 5000){
//            @Override
//            protected void onTick(){
//                System.out.println(message);
//                if(getTickCount() == 6){
//                    doDelete();
//                }
//            }
//        });
//------------------------------------------------------
// Variantas 2
//------------------------------------------------------
//        addBehaviour(new TickerBehaviour(this, 5000){
//            @Override
//            protected void onTick(){
//                System.out.println(message);
//                counter++;
//                if(counter == 6){
//                    stopAgent = true;
//                }
//            }
//        });
//        addBehaviour(new CyclicBehaviour(this) {
//            @Override
//            public void action(){
//                if(stopAgent){
//                    doDelete();
//                }
//            }
//        });
//------------------------------------------------------
// Variantas 3
//------------------------------------------------------
//        addBehaviour(new TickerBehaviour(this, 5000){
//            @Override
//            protected void onTick(){
//                System.out.println(message);
//            }
//        });
//        addBehaviour(new WakerBehaviour(this, 30000){
//            @Override
//            protected void onWake(){
//                doDelete();
//            }
//        });
//------------------------------------------------------
// Variantas 4
//------------------------------------------------------
        addBehaviour(new TickerBehaviour(this, 1000){
            @Override
            protected void onTick(){
                System.out.println("Current time: " + getTickCount() + " s.");
                if(getTickCount() % 5 == 0){
                    System.out.println(message);
                }
                if(getTickCount() == 30){
                    doDelete();
                }
            }
        });
    }
}