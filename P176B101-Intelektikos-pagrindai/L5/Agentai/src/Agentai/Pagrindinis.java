package Agentai;
import jade.core.AID;
import jade.core.Agent;
import jade.core.Profile;
import jade.core.ProfileImpl;
import jade.core.behaviours.CyclicBehaviour;
import jade.wrapper.AgentContainer;
import jade.wrapper.AgentController;
import jade.core.behaviours.OneShotBehaviour;
import jade.core.behaviours.TickerBehaviour;
import jade.core.behaviours.WakerBehaviour;
import jade.lang.acl.ACLMessage;
import jade.wrapper.ContainerController;
import jade.wrapper.StaleProxyException;
import java.util.logging.Level;
import java.util.logging.Logger;
import jade.core.Runtime;

// Demo
//public class Pagrindinis extends Agent{
//    private AgentController AC = null;
//    private String pack = "Agentai";
//    @Override
//    protected void setup(){
//        addBehaviour(new OneShotBehaviour() {
//            @Override
//            public void action() {
//                System.out.println("----------------------------------------------------");
//                SukurtiAgenta("Papildomas");
//                System.out.println("----------------------------------------------------");
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
//                    if (vardas.equals("Papildomas")){
//                        turinys = zinute.getContent();
//                        ACLMessage atsakymas;
//                        atsakymas = new ACLMessage(ACLMessage.INFORM);
//                        atsakymas.addReceiver(new AID(vardas, AID.ISLOCALNAME));
//                        System.out.println("Iš agento " + vardas + " gauta žinutė: ");
//                        System.out.println(turinys);
//                        atsakymas.setContent("Pagrindinis agentas patvirtina gavęs žinutę");
//                        send(atsakymas);
//                    }
//                }
//                else{
//                    block();
//                }
//            }
//        });
//    }
//    
//    private void SukurtiAgenta(String Pav){
//        try{
//            AgentContainer Konteineris = (AgentContainer) getContainerController();
//            AC = Konteineris.createNewAgent(Pav, pack + "." + Pav, null);
//            AC.start();
//            System.out.println("----------------------------------------------------");
//            System.out.println("Pagrindinis agentas: " + getLocalName());
//            System.out.println("Pagrindinio agento sukurtas agentas: " + Pav);
//            System.out.println("Konteineris: " + Konteineris.getContainerName());
//            System.out.println("----------------------------------------------------");
//        }
//        catch(Exception any){
//            any.printStackTrace();
//        }
//    }
//}

// Savarankiška užduotis Nr. 1
// Arguments: -name Platforma -gui PAG_Agentas:Agentai.Pagrindinis("Zinutes tekstas")
//public class Pagrindinis extends Agent{
//    private AgentController AC = null;
//    private String pack = "Agentai";
//    @Override
//    protected void setup(){
//        Object args[] = getArguments();
//        String message = args[0].toString();
//        addBehaviour(new OneShotBehaviour() {
//            @Override
//            public void action() {
//                System.out.println("Pagrindinis agentas pradėjo darbą.");
//                SukurtiAgenta("Papildomas");
//            }
//        });
//        addBehaviour(new TickerBehaviour(this, 2000) {
//            @Override
//            protected void onTick() {
//                ACLMessage zinute;
//                zinute = new ACLMessage(ACLMessage.INFORM);
//                zinute.addReceiver(new AID("Papildomas", AID.ISLOCALNAME));
//                zinute.setContent(message);
//                send(zinute);
//            }
//        });
//        // Testavimui, ar papildomas agentas prieš darbo pabaigą išsiunčia žinutę
////        addBehaviour(new CyclicBehaviour() {
////            @Override
////            public void action() {
////                jade.lang.acl.ACLMessage zinute = myAgent.receive();
////                if(zinute != null){
////                    String vardas;
////                    vardas = zinute.getSender().getName();
////                    vardas = vardas.substring(0, vardas.indexOf("@"));
////                    if (vardas.equals("Papildomas")){
////                        System.out.println("OK");
////                    }
////                }
////                else{
////                    block();
////                }
////            }
////        });
//    }
//    
//    private void SukurtiAgenta(String Pav){
//        try{
//            AgentContainer Konteineris = (AgentContainer) getContainerController();
//            System.out.println("Sukuriamas papildomas agentas.");
//            AC = Konteineris.createNewAgent(Pav, pack + "." + Pav, null);
//            AC.start();
//        }
//        catch(Exception any){
//            any.printStackTrace();
//        }
//    }
//}

// Savarankiško darbo užduotis Nr. 2
// Arguments: -name Platforma -gui PAG_Agentas:Agentai.Pagrindinis(5000)
//public class Pagrindinis extends Agent{
//    private AgentController AC = null;
//    private String pack = "Agentai";
//    @Override
//    protected void setup(){
//        Object args[] = getArguments();
//        String turnOffTime = args[0].toString();
//        addBehaviour(new OneShotBehaviour() {
//            @Override
//            public void action() {
//                System.out.println("Pagrindinis agentas pradėjo darbą.");
//                SukurtiAgenta("Papildomas");
//            }
//        });
//        addBehaviour(new TickerBehaviour(this, 5000) {
//            @Override
//            protected void onTick() {
//                ACLMessage zinute;
//                zinute = new ACLMessage(ACLMessage.INFORM);
//                zinute.addReceiver(new AID("Papildomas", AID.ISLOCALNAME));
//                zinute.setContent(turnOffTime);
//                send(zinute);
//            }
//        });
//    }
//    
//    private void SukurtiAgenta(String Pav){
//        try{
//            AgentContainer Konteineris = (AgentContainer) getContainerController();
//            System.out.println("Sukuriamas papildomas agentas.");
//            AC = Konteineris.createNewAgent(Pav, pack + "." + Pav, null);
//            AC.start();
//        }
//        catch(Exception any){
//            any.printStackTrace();
//        }
//    }
//}

// Savarankiško darbo užduotis Nr. 3
// Arguments: -name Platforma -gui PAG_Agentas:Agentai.Pagrindinis("Zinutes tekstas",5000)
public class Pagrindinis extends Agent{
    private final String pack = "Agentai";
    final static String name_Agent = "Papildomas";
    final static String name_Agent2 = "Papildomas2";
    private AgentController AC;
    private AgentController AC2;
    private boolean switcher = true; // true - Papildomas, false - papildomas 2 
    
    @Override
    protected void setup(){
        Object args[] = getArguments();
        String turnOffTime = args[1].toString();
        
        addBehaviour(new OneShotBehaviour() {
            @Override
            public void action() {
                System.out.println("Pagrindinis agentas pradėjo darbą.");
                AC = SukurtiAgenta(name_Agent, args);
                AC2 = SukurtiAgenta(name_Agent2, args);
            }
        });
        addBehaviour(new TickerBehaviour(this, 5000) {
            @Override
            protected void onTick() {
                ACLMessage zinute;
                String agentName = switcher ? name_Agent : name_Agent2;
                zinute = new ACLMessage(ACLMessage.INFORM);
                zinute.addReceiver(new AID(agentName, AID.ISLOCALNAME));
                zinute.setContent(turnOffTime);
                send(zinute);
            }
        });
        addBehaviour(new CyclicBehaviour() {
            @Override
            public void action() {
                jade.lang.acl.ACLMessage zinute = myAgent.receive();
                if(zinute != null){
                    String vardas;
                    vardas = zinute.getSender().getName();
                    vardas = vardas.substring(0, vardas.indexOf("@"));
                    if (vardas.equals(name_Agent)){
                        switcher = false;
                        try {
                            System.out.println(zinute.getContent());
                            AC2.activate();
                        } catch (StaleProxyException ex) {
                            Logger.getLogger(Pagrindinis.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                    else if(vardas.equals(name_Agent2)){
                        switcher = true;
                        try {
                            System.out.println(zinute.getContent());
                            AC.activate();
                        } catch (StaleProxyException ex) {
                            Logger.getLogger(Pagrindinis.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                }
                else{
                    block();
                }
            }
        });
    }
    
    private AgentController SukurtiAgenta(String Pav, Object[] args){
        AgentController AController = null;
        try{
            AgentContainer Konteineris = (AgentContainer) getContainerController();
            System.out.println("Sukuriamas agentas: " + Pav);
            AController = Konteineris.createNewAgent(Pav, pack + "." + name_Agent, args);
            AController.start();
        }
        catch(Exception any){
            any.printStackTrace();
        }
        return AController;
    }
}

//--------------------------------------------------------------------------------------
// 5.3 dalis
//--------------------------------------------------------------------------------------
// Arguments: -name Platforma -gui PAG_Agentas:Agentai.Pagrindinis(Turinys)
//public class Pagrindinis extends Agent{
//    private final String pack = "Agentai";
//    final static String name_Agent = "Papildomas";
//    private AgentController AC;
//    
//    @Override
//    protected void setup(){
//        Object[] args = getArguments();
//        String Argumentas = args[0].toString();
//        addBehaviour(new OneShotBehaviour() {
//            @Override
//            public void action() {
//                String vardas;
//                vardas = "Klase";
//                System.out.println("Pagrindinis agentas pradėjo darbą.");
//                ContainerController cc = SukurtiKonteineri(myAgent.getProperty(Profile.MAIN_HOST, null),
//                                                           myAgent.getProperty(Profile.MAIN_PORT, null), 
//                                                           vardas);
//                SukurtiAgentaKonteineryje(name_Agent, cc);
//            }
//        });
//        addBehaviour(new TickerBehaviour(this, 2000) {
//            @Override
//            protected void onTick() {
//                ACLMessage cfp = new ACLMessage(ACLMessage.PROPOSE);
//                cfp.addReceiver(new AID(name_Agent, AID.ISLOCALNAME));
//                cfp.setContent(Argumentas);
//                myAgent.send(cfp);
//            }
//        });
//    }
//    
//    private ContainerController SukurtiKonteineri(String Hostas, String Portas, String Vardas){
//        Runtime rt = Runtime.instance();
//        Profile p = new ProfileImpl();
//        p.setParameter(Profile.MAIN_HOST, Hostas);
//        p.setParameter(Profile.MAIN_PORT, Portas);
//        p.setParameter(Profile.CONTAINER_NAME, Vardas);
//        return rt.createAgentContainer(p);
//    }
//    
//    private void SukurtiAgentaKonteineryje(String Pav, ContainerController Konteineris){
//        try{
//            AC = Konteineris.createNewAgent(Pav, pack + "." + Pav, null);
//            System.out.println("Pagrindinis agentas: " + getLocalName());
//            System.out.println("Sukuriamas agentas: " + Pav);
//            System.out.println("Konteinerio pavadinimas: " + Konteineris.getContainerName());
//            AC.start();
//        }
//        catch(Exception any){
//            any.printStackTrace();
//        }
//    }
//}

//--------------------------------------------------------------------------------------
// 5.4 dalis
//--------------------------------------------------------------------------------------
// Arguments: -name Platforma -gui PAG_Agentas:Agentai.Pagrindinis
//public class Pagrindinis extends Agent{
//    private final String pack = "Agentai";
//    final static String name_Agent = "Papildomas";
//    final static String name_Agent2 = "Papildomas2";
//    final static String name_Agent3 = "Mobilus";
//    private AgentController AC;
//    
//    @Override
//    protected void setup(){
//        addBehaviour(new OneShotBehaviour() {
//            @Override
//            public void action() {
//                String vardas = "Klase";
//                String vardas2 = "Klase2";
//                System.out.println("Pagrindinis agentas pradėjo darbą.");
//                ContainerController cc = SukurtiKonteineri(myAgent.getProperty(Profile.MAIN_HOST, null),
//                                                           myAgent.getProperty(Profile.MAIN_PORT, null), 
//                                                           vardas);
//                ContainerController cr = SukurtiKonteineri(myAgent.getProperty(Profile.MAIN_HOST, null),
//                                                           myAgent.getProperty(Profile.MAIN_PORT, null), 
//                                                           vardas2);
//                SukurtiAgentaKonteineryje(name_Agent, cc);
//                SukurtiAgentaKonteineryje(name_Agent2, cr);
//                SukurtiAgenta(name_Agent3);
//            }
//        });
//    }
//    
//    private ContainerController SukurtiKonteineri(String Hostas, String Portas, String Vardas){
//        Runtime rt = Runtime.instance();
//        Profile p = new ProfileImpl();
//        p.setParameter(Profile.MAIN_HOST, Hostas);
//        p.setParameter(Profile.MAIN_PORT, Portas);
//        p.setParameter(Profile.CONTAINER_NAME, Vardas);
//        return rt.createAgentContainer(p);
//    }
//    
//    private void SukurtiAgentaKonteineryje(String Pav, ContainerController Konteineris){
//        try{
//            AC = Konteineris.createNewAgent(Pav, pack + "." + Pav, null);
//            System.out.println("Pagrindinis agentas: " + getLocalName());
//            System.out.println("Sukuriamas agentas: " + Pav);
//            System.out.println("Konteinerio pavadinimas: " + Konteineris.getContainerName());
//            AC.start();
//        }
//        catch(Exception any){
//            any.printStackTrace();
//        }
//    }
//    
//    private void SukurtiAgenta(String Pav){
//        try{
//            AgentContainer Konteineris = (AgentContainer) getContainerController();
//            System.out.println("Sukuriamas papildomas agentas.");
//            AC = Konteineris.createNewAgent(Pav, pack + "." + Pav, null);
//            AC.start();
//        }
//        catch(Exception any){
//            any.printStackTrace();
//        }
//    }
//}
