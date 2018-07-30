package Agentai;

import jade.core.AID;
import jade.core.Agent;
import jade.core.ContainerID;
import jade.core.Profile;
import jade.core.behaviours.CyclicBehaviour;
import jade.core.behaviours.OneShotBehaviour;
import jade.core.behaviours.TickerBehaviour;
import jade.lang.acl.ACLMessage;

public class Mobilus extends Agent{
    private int papildomas_accepted = 0;
    private int papildomas_all = 0;
    private int papildomas2_accepted = 0;
    private int papildomas2_all = 0;
    private boolean switcher = true; // true - Klase, false - Klase2
    @Override
    protected void setup(){
        addBehaviour(new OneShotBehaviour(this) {
            @Override
            public void action() {
                System.out.println(getAID().getLocalName() + " agentas pradėjo darbą.");
            }
        });
        addBehaviour(new TickerBehaviour(this, 1000) {
            @Override
            protected void onTick() {
                if(getTickCount() == 21){
                    System.out.println("----------------------------------------------------");
                    System.out.println("Mobilusis agentas atliko 10 iteracijų, rezultatai:");
                    System.out.println("Agentas Papildomas:  priimti - " + papildomas_accepted + ", atmesti - " + (papildomas_all - papildomas_accepted) + ", viso - " + papildomas_all + ".");
                    System.out.println("Agentas Papildomas2: priimti - " + papildomas2_accepted + ", atmesti - " + (papildomas2_all - papildomas2_accepted) + ", viso - " + papildomas2_all + ".");
                    System.out.println("----------------------------------------------------");
                }
                else if(getTickCount() <= 20){
                    ContainerID dest = new ContainerID();
                    String name = switcher ? "Klase" : "Klase2";
                    dest.setName(name);
                    myAgent.doMove(dest);
                }
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
                    if (vardas.equals("Papildomas")){
                        String content = zinute.getContent();
                        papildomas_accepted += content.equals("Accept") ? 1 : 0;
                        papildomas_all++;
                    }
                    else if(vardas.equals("Papildomas2")){
                        String content = zinute.getContent();
                        papildomas2_accepted += content.equals("Accept") ? 1 : 0;
                        papildomas2_all++;
                    }
                }
                else{
                    block();
                }
            }
        });
    }
    @Override
    protected void afterMove(){
        addBehaviour(new OneShotBehaviour() {
            @Override
            public void action() {
                String containerName = myAgent.getProperty(Profile.CONTAINER_NAME, null);
                if (containerName == null){
                    containerName = "Main-Container";
                }
                System.out.println("----------------------------------------------------");
                System.out.println(getAID().getLocalName() + " permigravo į " + containerName);
                if(containerName.equals("Klase") || containerName.equals("Klase2")){
                    ACLMessage message = new ACLMessage(ACLMessage.PROPOSE);
                    String receiver = containerName.equals("Klase") ? "Papildomas" : "Papildomas2";
                    message.addReceiver(new AID(receiver, AID.ISLOCALNAME));
                    message.setContent("Propose message.");
                    myAgent.send(message);
                    switcher = !switcher;
                }
            }
        });
    }
}