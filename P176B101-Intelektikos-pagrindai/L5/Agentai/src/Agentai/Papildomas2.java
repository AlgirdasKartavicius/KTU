package Agentai;
import jade.core.AID;
import jade.core.Agent;
import jade.core.behaviours.CyclicBehaviour;
import jade.core.behaviours.OneShotBehaviour;
import jade.lang.acl.ACLMessage;
import java.util.Random;

public class Papildomas2 extends Agent{
    @Override
    protected void setup(){
        addBehaviour(new OneShotBehaviour(this) {
            @Override
            public void action() {
                System.out.println(getAID().getLocalName() + " agentas pradėjo darbą.");
            }
        });
        addBehaviour(new CyclicBehaviour(this) {
            @Override
            public void action() {
                jade.lang.acl.ACLMessage zinute = myAgent.receive();
                if(zinute != null){
                    String vardas;
                    vardas = zinute.getSender().getName();
                    vardas = vardas.substring(0, vardas.indexOf("@"));
                    if (vardas.equals("Mobilus")){
                        Random rnd = new Random();
                        boolean accept = rnd.nextBoolean();
                        if(accept){
                            System.out.println(getAID().getLocalName() + ": Pasiūlymas priimamas.");
                            ACLMessage message = new ACLMessage(ACLMessage.ACCEPT_PROPOSAL);
                            message.addReceiver(new AID(vardas, AID.ISLOCALNAME));
                            message.setContent("Accept");
                            send(message);     
                        }
                        else{
                            System.out.println(getAID().getLocalName() + ": Pasiūlymas atmetamas.");
                            ACLMessage message = new ACLMessage(ACLMessage.REJECT_PROPOSAL);
                            message.addReceiver(new AID(vardas, AID.ISLOCALNAME));
                            message.setContent("Reject");
                            send(message);     
                        }
                    }
                }
                else{
                    block();
                }
            }
        });
    }
}