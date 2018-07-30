package Agentai;
import jade.core.AID;
import jade.core.Agent;
import jade.core.behaviours.CyclicBehaviour;
import jade.core.behaviours.OneShotBehaviour;
import jade.core.behaviours.TickerBehaviour;
import jade.core.behaviours.WakerBehaviour;
import jade.lang.acl.ACLMessage;
import jade.wrapper.AgentContainer;
import jade.wrapper.AgentController;
import java.util.Random;

// Demo
//public class Papildomas extends Agent{
//    @Override
//    protected void setup(){
//        addBehaviour(new OneShotBehaviour() {
//            @Override
//            public void action() {
//                System.out.println("----------------------------------------------------");
//                System.out.println("Papildomas Agentas");
//                System.out.println("----------------------------------------------------");
//            }
//        });
//        addBehaviour(new TickerBehaviour(this, 5000) {
//            @Override
//            protected void onTick() {
//                ACLMessage zinute;
//                zinute = new ACLMessage(ACLMessage.INFORM);
//                zinute.addReceiver(new AID("PAG_Agentas", AID.ISLOCALNAME));
//                zinute.setContent("Papildomo agento žinutės turinys");
//                send(zinute);
//            }
//        });
//    }
//}

// Savarankiško darbo užduotis Nr. 1
//public class Papildomas extends Agent{
//    @Override
//    protected void setup(){
//        addBehaviour(new OneShotBehaviour() {
//            @Override
//            public void action() {
//                System.out.println("Papildomas agentas pradėjo darbą.");
//            }
//        });
//        addBehaviour(new CyclicBehaviour() {
//            @Override
//            public void action() {
//                jade.lang.acl.ACLMessage zinute = myAgent.receive();
//                if(zinute != null){
//                    String vardas;
//                    String turinys;
//                    vardas = zinute.getSender().getName();
//                    vardas = vardas.substring(0, vardas.indexOf("@"));
//                    if (vardas.equals("PAG_Agentas")){
//                        turinys = zinute.getContent();
//                        System.out.println(turinys);
//                        ACLMessage confirm = new ACLMessage(ACLMessage.CONFIRM);
//                        confirm.addReceiver(new AID("PAG_Agentas", AID.ISLOCALNAME));
//                        send(confirm);
//                    }
//                }
//                else{
//                    block();
//                }
//            }
//        });
//    }
//}

// Savarankiško darbo užduotis Nr. 2
//public class Papildomas extends Agent{
//    @Override
//    protected void setup(){
//        addBehaviour(new OneShotBehaviour() {
//            @Override
//            public void action() {
//                System.out.println("Papildomas agentas pradėjo darbą.");
//            }
//        });
//        addBehaviour(new CyclicBehaviour() {
//            @Override
//            public void action() {
//                jade.lang.acl.ACLMessage zinute = myAgent.receive();
//                if(zinute != null){
//                    String vardas;
//                    String turnOffAfter;
//                    vardas = zinute.getSender().getName();
//                    vardas = vardas.substring(0, vardas.indexOf("@"));
//                    if (vardas.equals("PAG_Agentas")){
//                        turnOffAfter = zinute.getContent();
//                        System.out.println(turnOffAfter);
//                        ACLMessage confirm = new ACLMessage(ACLMessage.CONFIRM);
//                        confirm.addReceiver(new AID("PAG_Agentas", AID.ISLOCALNAME));
//                        send(confirm);
//                        int time = Integer.parseInt(turnOffAfter);
//                        myAgent.addBehaviour(new WakerBehaviour(myAgent, time){
//                            @Override
//                            protected void onWake(){
//                                doDelete();
//                                ACLMessage zinute;
//                                // Pagal užduotį reikia siųsti Confirm tipo žinutę
//                                // zinute = new ACLMessage(ACLMessage.INFORM);
//                                zinute = new ACLMessage(ACLMessage.INFORM);
//                                zinute.addReceiver(new AID("PAG_Agentas", AID.ISLOCALNAME));
//                                zinute.setContent("Papildomas agentas baigia darbą");
//                                send(zinute);
//                            }
//                        });
//                    }
//                }
//                else{
//                    block();
//                }
//            }
//        });
//    }
//}

// Savarankiško darbo užduotis Nr. 3
public class Papildomas extends Agent{
    @Override
    protected void setup(){
        Object args[] = getArguments();
        String arg_message = args[0].toString();
        addBehaviour(new OneShotBehaviour(this) {
            @Override
            public void action() {
                System.out.println(getAID().getLocalName() + " agentas pradėjo darbą.");
                if (getAID().getLocalName().equals(Pagrindinis.name_Agent2)){
                    doSuspend();
                }
            }
        });
        addBehaviour(new CyclicBehaviour(this) {
            @Override
            public void action() {
                jade.lang.acl.ACLMessage zinute = myAgent.receive();
                if(zinute != null){
                    String vardas;
                    String turinys;
                    vardas = zinute.getSender().getName();
                    vardas = vardas.substring(0, vardas.indexOf("@"));
                    if (vardas.equals("PAG_Agentas")){
                        ACLMessage informAboutMessage = new ACLMessage(ACLMessage.INFORM);
                        informAboutMessage.addReceiver(new AID("PAG_Agentas", AID.ISLOCALNAME));
                        //send(informAboutMessage);
                        int time = Integer.parseInt(zinute.getContent());
                        System.out.println(getAID().getLocalName() + ": " + time);
                        myAgent.addBehaviour(new WakerBehaviour(myAgent, time){
                            @Override
                            protected void onWake(){                                
                                ACLMessage confirm = new ACLMessage(ACLMessage.CONFIRM);
                                confirm.addReceiver(new AID("PAG_Agentas", AID.ISLOCALNAME));
                                confirm.setContent(getAID().getLocalName() + ": baigiau darbą");
                                System.out.println(getAID().getLocalName() + ": " + arg_message);
                                send(confirm);              
                                doSuspend();
                            }
                        });
                    }
                }
                else{
                    block();
                }
            }
        });
    }
}

//----------------------------------------------------------------------------
// 5.3 dalis
//----------------------------------------------------------------------------
//public class Papildomas extends Agent{
//    @Override
//    protected void setup(){
//        addBehaviour(new OneShotBehaviour(this) {
//            @Override
//            public void action() {
//                System.out.println(getAID().getLocalName() + " agentas pradėjo darbą.");
//            }
//        });
//        addBehaviour(new CyclicBehaviour(this) {
//            @Override
//            public void action() {
//                jade.lang.acl.ACLMessage zinute = myAgent.receive();
//                if(zinute != null){
//                    String vardas;
//                    vardas = zinute.getSender().getName();
//                    vardas = vardas.substring(0, vardas.indexOf("@"));
//                    if (vardas.equals("PAG_Agentas")){
//                        Random rnd = new Random();
//                        boolean accept = rnd.nextBoolean();
//                        if(accept){
//                            System.out.println("Pasiūlymas priimamas.");
//                            ACLMessage message = new ACLMessage(ACLMessage.ACCEPT_PROPOSAL);
//                            message.addReceiver(new AID(vardas, AID.ISLOCALNAME));
//                            message.setContent("Atmetu pasiūlymą.");
//                            send(message);     
//                        }
//                        else{
//                            System.out.println("Pasiūlymas atmetamas.");
//                            ACLMessage message = new ACLMessage(ACLMessage.REJECT_PROPOSAL);
//                            message.addReceiver(new AID(vardas, AID.ISLOCALNAME));
//                            message.setContent("Priimu pasiūlymą.");
//                            send(message);     
//                        }
//                    }
//                }
//                else{
//                    block();
//                }
//            }
//        });
//    }
//}

//----------------------------------------------------------------------------
// 5.4 dalis
//----------------------------------------------------------------------------
//public class Papildomas extends Agent{
//    @Override
//    protected void setup(){
//        addBehaviour(new OneShotBehaviour(this) {
//            @Override
//            public void action() {
//                System.out.println(getAID().getLocalName() + " agentas pradėjo darbą.");
//            }
//        });
//        addBehaviour(new CyclicBehaviour(this) {
//            @Override
//            public void action() {
//                jade.lang.acl.ACLMessage zinute = myAgent.receive();
//                if(zinute != null){
//                    String vardas;
//                    vardas = zinute.getSender().getName();
//                    vardas = vardas.substring(0, vardas.indexOf("@"));
//                    if (vardas.equals("Mobilus")){
//                        Random rnd = new Random();
//                        boolean accept = rnd.nextBoolean();
//                        if(accept){
//                            System.out.println(getAID().getLocalName() + ": Pasiūlymas priimamas.");
//                            ACLMessage message = new ACLMessage(ACLMessage.ACCEPT_PROPOSAL);
//                            message.addReceiver(new AID(vardas, AID.ISLOCALNAME));
//                            message.setContent("Accept");
//                            send(message);     
//                        }
//                        else{
//                            System.out.println(getAID().getLocalName() + ": Pasiūlymas atmetamas.");
//                            ACLMessage message = new ACLMessage(ACLMessage.REJECT_PROPOSAL);
//                            message.addReceiver(new AID(vardas, AID.ISLOCALNAME));
//                            message.setContent("Reject");
//                            send(message);     
//                        }
//                    }
//                }
//                else{
//                    block();
//                }
//            }
//        });
//    }
//}