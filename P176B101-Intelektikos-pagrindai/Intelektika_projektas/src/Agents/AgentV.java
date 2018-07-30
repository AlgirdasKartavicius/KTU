package Agents;

import Libraries.Constants;
import jade.core.AID;
import jade.core.Agent;
import jade.core.behaviours.CyclicBehaviour;
import jade.core.behaviours.TickerBehaviour;
import jade.lang.acl.ACLMessage;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Random;

public class AgentV extends Agent{
    @Override
    protected void setup(){
        System.out.println(getAID().getLocalName() + " has been created.");
        // Behaviour for incoming messages handling
        addBehaviour(new CyclicBehaviour() {
            @Override
            public void action() {
                ACLMessage receivedMessage = myAgent.receive();
                if(receivedMessage != null){
                    switch(receivedMessage.getPerformative()){
                        // Received message from Agent_A to provide answer about dishes prices
                        case ACLMessage.REQUEST:
                            // Generating message with answers about dishes prices
                            ACLMessage answerMessage = receivedMessage.createReply();
                            answerMessage.setPerformative(ACLMessage.INFORM);
                            ArrayList<Double> answersList = generatePrices(1);
                            try {
                                answerMessage.setContentObject(answersList);
                            } catch (IOException ex) {}
                            myAgent.send(answerMessage);
                            break;
                        // Received the answer from Agent_A about restaurant's quality
                        case ACLMessage.INFORM:
                            System.out.println(receivedMessage.getContent());
                            break;
                    }
                    
                }
                else{
                    block();
                }
            }
        });
        // Behaviour for simulation of tourists and their questions about dishes prices
        addBehaviour(new TickerBehaviour(this, Constants.ASKING_TIME_TOURIST) {
            @Override
            protected void onTick() {
                // Generating message for Agent_A about dishes prices in restaurant
                ACLMessage message = new ACLMessage(ACLMessage.REQUEST);
                message.addReceiver(new AID(Constants.NAME_AGENT_A, AID.ISLOCALNAME));
                ArrayList<Double> pricesList = generatePrices(5);
                try {
                    message.setContentObject(pricesList);
                } catch (IOException ex) {}
                myAgent.send(message);
            }
        });
    }
    
    // Generating random prices using price ranges from constants
    private ArrayList<Double> generatePrices(int rangeOffset){
        ArrayList<Double> answersList = new ArrayList<>();
        ArrayList<Double> rangesList = Constants.constantsToArray();
        Random rnd = new Random();
        for (int i = 0; i < rangesList.size(); i+= (rangeOffset+1)){
            Double minRangeDouble = rangesList.get(i)*100;
            Double maxRangeDouble = rangesList.get(i+rangeOffset)*100;
            answersList.add((double)(rnd.nextInt(maxRangeDouble.intValue() - minRangeDouble.intValue() + 1) + minRangeDouble.intValue())/100);
        }
        return answersList;
    }
}