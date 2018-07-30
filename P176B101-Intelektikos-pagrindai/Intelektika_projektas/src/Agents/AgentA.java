package Agents;

import Libraries.Constants;
import jade.core.AID;
import jade.core.Agent;
import jade.core.behaviours.CyclicBehaviour;
import jade.core.behaviours.OneShotBehaviour;
import jade.core.behaviours.TickerBehaviour;
import jade.lang.acl.ACLMessage;
import jade.lang.acl.UnreadableException;
import jade.wrapper.AgentContainer;
import jade.wrapper.AgentController;
import jade.wrapper.StaleProxyException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;

public class AgentA extends Agent{ 
    // List dishesList - answers from users
    // List in list (ArrayList<Double>):
    //      Index 0-2: Coffee   (cheap, normal, expensive)
    //      Index 3-5: Soup     (cheap, normal, expensive)
    //      Index 6-8: Steak    (cheap, normal, expensive)
    private final ArrayList<ArrayList<Double>> allAnswersList;
    // DishesList input functions
    private final ArrayList<ArrayList<Double>> inputFunctions;
    int answersCounter = 0;
    private AgentController AC = null;
    
    // Constructor
    public AgentA(){
        this.inputFunctions = new ArrayList<>();
        this.allAnswersList = new ArrayList<>();
        initializeInputFunctions();
    }
    
    @Override
    protected void setup(){
        // Behaviour purpose - create all necessary agents
        addBehaviour(new OneShotBehaviour() {
            @Override
            public void action() {
                System.out.println(getAID().getLocalName() + " has been created.");
                createAgent(Constants.NAME_AGENT_V);
                createAgent(Constants.NAME_AGENT_SP);
            }
        });
        // Ask AgentV for answers about dishes prices
        addBehaviour(new TickerBehaviour(this, Constants.ASKING_TIME) {
            @Override
            protected void onTick() {
                ACLMessage message = new ACLMessage(ACLMessage.REQUEST);
                message.addReceiver(new AID(Constants.NAME_AGENT_V, AID.ISLOCALNAME));
                myAgent.send(message);
            }
        });
        // Behaviour for incoming messages handling
        addBehaviour(new CyclicBehaviour() {
            @Override
            public void action() {
                ACLMessage receivedMessage = myAgent.receive();
                if(receivedMessage != null){
                    String agentName = receivedMessage.getSender().getName();
                    agentName = agentName.substring(0, agentName.indexOf("@"));
                    // Check sender's name
                    if(agentName.equals(Constants.NAME_AGENT_V)){
                        // Check received message's type
                        switch(receivedMessage.getPerformative()){
                            // Received meesage about dishes prices from AgentV
                            case ACLMessage.INFORM:
                                // Getting prices
                                ArrayList<Double> answersList = new ArrayList<>();
                                try {
                                    answersList = (ArrayList<Double>)receivedMessage.getContentObject();
                                } catch (UnreadableException ex) {}
                                allAnswersList.add(answersList);
                                // Check if input functions update is needed
                                if(++answersCounter % 5 == 0){
                                    // Calculate average of last 5 answers about dishes price
                                    int index = allAnswersList.size()-5;
                                    ArrayList<Double> resultsSum = new ArrayList<>(Arrays.asList(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0));
                                    for (int i = index; i < allAnswersList.size(); i++){
                                        answersList = allAnswersList.get(i);
                                        for (int j = 0; j < answersList.size(); j++){
                                            resultsSum.set(j, answersList.get(j) + resultsSum.get(j));
                                        }
                                    }
                                    // Calculate average price of every dish and update input functions
                                    for(int i = 0; i < inputFunctions.size(); i++){
                                        inputFunctions.get(i).set(1, Math.round((Double)((inputFunctions.get(i).get(1)*(answersCounter-5) + resultsSum.get(i))/answersCounter)*100.0)/100.0);
                                    }
                                    // Inform AgentSP about input functions changes
                                    ACLMessage message = new ACLMessage(ACLMessage.INFORM);
                                    message.addReceiver(new AID(Constants.NAME_AGENT_SP, AID.ISLOCALNAME));
                                    try {
                                        message.setContentObject(inputFunctions);
                                    } catch (IOException ex) {}
                                    myAgent.send(message);
                                }
                                break;
                            // Received message from tourist to identify restaurant quality
                            case ACLMessage.REQUEST:
                                ArrayList<Double> touristQuestionPrices = new ArrayList<>();
                                try {
                                    touristQuestionPrices = (ArrayList<Double>)receivedMessage.getContentObject();
                                } catch (UnreadableException ex) {}
                                // Generating message for Agent_SP in order to identify restaurant's quality
                                ACLMessage message = new ACLMessage(ACLMessage.REQUEST);
                                message.addReceiver(new AID(Constants.NAME_AGENT_SP, AID.ISLOCALNAME));
                                try {
                                    message.setContentObject(touristQuestionPrices);
                                } catch (IOException ex) {}
                                myAgent.send(message);
                                break;
                        }
                    }
                    // If the message's sender is Agent_SP
                    else if(agentName.equals(Constants.NAME_AGENT_SP)){
                        // Generating message for Agent_V to send the answer to the question about restaurant's quality
                        ACLMessage message = new ACLMessage(ACLMessage.INFORM);
                        message.setContent(receivedMessage.getContent());
                        message.addReceiver(new AID(Constants.NAME_AGENT_V, AID.ISLOCALNAME));
                        myAgent.send(message);
                    }
                }
                else{
                    block();
                }
            }
        });
    }
    
    // Function which creates an agent of name Pav and appends it to main container
    private void createAgent(String Pav){
        try{
            AgentContainer Konteineris = (AgentContainer) getContainerController();
            AC = Konteineris.createNewAgent(Pav, Constants.AGENTS_PACK + "." + Pav, null);
            AC.start();
        }
        catch(StaleProxyException any){}
    }
    
    // Function for dishes prices input functions initialization
    private void initializeInputFunctions(){
        inputFunctions.add(new ArrayList<>(Arrays.asList(Constants.COFFEE_CHEAP_MIN, 0.0, Constants.COFFEE_CHEAP_MAX)));
        inputFunctions.add(new ArrayList<>(Arrays.asList(Constants.COFFEE_NORMAL_MIN, 0.0, Constants.COFFEE_NORMAL_MAX)));
        inputFunctions.add(new ArrayList<>(Arrays.asList(Constants.COFFEE_EXPENSIVE_MIN, 0.0, Constants.COFFEE_EXPENSIVE_MAX)));
        inputFunctions.add(new ArrayList<>(Arrays.asList(Constants.SOUP_CHEAP_MIN, 0.0, Constants.SOUP_CHEAP_MAX)));
        inputFunctions.add(new ArrayList<>(Arrays.asList(Constants.SOUP_NORMAL_MIN, 0.0, Constants.SOUP_NORMAL_MAX)));
        inputFunctions.add(new ArrayList<>(Arrays.asList(Constants.SOUP_EXPENSIVE_MIN, 0.0, Constants.SOUP_EXPENSIVE_MAX)));
        inputFunctions.add(new ArrayList<>(Arrays.asList(Constants.STEAK_CHEAP_MIN, 0.0, Constants.STEAK_CHEAP_MAX)));
        inputFunctions.add(new ArrayList<>(Arrays.asList(Constants.STEAK_NORMAL_MIN, 0.0, Constants.STEAK_NORMAL_MAX)));
        inputFunctions.add(new ArrayList<>(Arrays.asList(Constants.STEAK_EXPENSIVE_MIN, 0.0, Constants.STEAK_EXPENSIVE_MAX)));
    }
}