package Agents;

import Libraries.Constants;
import jade.core.Agent;
import jade.core.behaviours.CyclicBehaviour;
import jade.lang.acl.ACLMessage;
import jade.lang.acl.UnreadableException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class AgentSP extends Agent {
    // The list of input functinos
    private ArrayList<ArrayList<Double>> inputFunctions;
    // The list of output functions
    private final ArrayList<ArrayList<Double>> outputFunctions;
    // Constructor
    public AgentSP(){
        this.inputFunctions = new ArrayList<>();
        this.outputFunctions = new ArrayList<>();
        // Initialising output functions list
        this.outputFunctions.add(new ArrayList<>(Arrays.asList(-1.0, Constants.OUTPUT_CHEAP_MIN, Constants.OUTPUT_CHEAP_MAX)));
        this.outputFunctions.add(new ArrayList<>(Arrays.asList(Constants.OUTPUT_AFFORDABLE_MIN, 5.0, Constants.OUTPUT_AFFORDABLE_MAX)));
        this.outputFunctions.add(new ArrayList<>(Arrays.asList(Constants.OUTPUT_LUXURIOUS_MIN, Constants.OUTPUT_LUXURIOUS_MAX, 11.0)));
    }
    @Override
    protected void setup(){
        System.out.println(getAID().getLocalName() + " has been created.");
        // Behaviour for incoming messages handling
        addBehaviour(new CyclicBehaviour() {
            @Override
            public void action() {
                ACLMessage receivedMessage = myAgent.receive();
                if(receivedMessage != null){
                    // Check received message's type
                    switch(receivedMessage.getPerformative()){
                        // Received message about input functions update
                        case ACLMessage.INFORM:
                            try {
                                // Updating input functions
                                inputFunctions = (ArrayList<ArrayList<Double>>)receivedMessage.getContentObject();
                            } catch (UnreadableException ex) {}
                            System.out.print("Input functions values: ");
                            System.out.println(inputFunctions);
                            break;
                        // Received a request to identify restaurant quality
                        case ACLMessage.REQUEST:
                            ArrayList<Double> touristQuestionPrices = new ArrayList<>();
                            try {
                                touristQuestionPrices = (ArrayList<Double>)receivedMessage.getContentObject();
                            } catch (UnreadableException ex) {}
                            System.out.print("Tourist prices: ");
                            System.out.println(touristQuestionPrices);
                            // Calculating fuzzy values from input functions using tourist's provided dishes prices
                            ArrayList<Double> fuzzyValues = calculateFuzzyValuesOfInput(touristQuestionPrices);
                            System.out.print("Calculated fuzzy values: ");
                            System.out.println(fuzzyValues);
                            // Calculating values of every rule using calculated fuzzy values
                            ArrayList<Double> rulesValues = calculateRulesValues(fuzzyValues);
                            System.out.print("Calculated rules values: ");
                            System.out.println(rulesValues);
                            // Defuzification using centroid method
                            double outputValue = calculateOutputUsingCentroid(calculateAggregatedFunctionsValuesFromRules(rulesValues));
                            System.out.print("Calculated output: ");
                            System.out.println(outputValue);
                            // Generating message for Agent_A about calculated restaurant quality
                            ACLMessage answerMessage = receivedMessage.createReply();
                            answerMessage.setPerformative(ACLMessage.CONFIRM);
                            answerMessage.setContent("Restaurant is: " + verbalizeOutputValue(outputValue));
                            myAgent.send(answerMessage);
                            break;
                    }
                }
                else{
                    block();
                }
            }
        });
    }
    
    // Function for fuzzy values calculation of every input function 
    private ArrayList<Double> calculateFuzzyValuesOfInput(ArrayList<Double> input){
        ArrayList<Double> fuzzyValues = new ArrayList<>();
        int inputIndex = 0;
        for(int i = 0; i < inputFunctions.size(); i++){
            switch((i+1)%3){
                // If the function is of type cheap (trapezium function)
                case 1:
                    fuzzyValues.add(calculateFuzzyValueFromFunction(inputFunctions.get(i), input.get(inputIndex), Constants.PRICE_CHEAP));
                    break;
                // If the function is of type normal (triangle function)
                case 2:
                    fuzzyValues.add(calculateFuzzyValueFromFunction(inputFunctions.get(i), input.get(inputIndex), Constants.PRICE_NORMAL));
                    break;
                // If the function is of type expensive (trapezium function)
                case 0:
                    fuzzyValues.add(calculateFuzzyValueFromFunction(inputFunctions.get(i), input.get(inputIndex), Constants.PRICE_EXPENSIVE));
                    inputIndex++;
                    break;
            }
        }
        return fuzzyValues;
    }
    
    // Function for getting y value from input function, when x is a dish price provided by tourist
    private double calculateFuzzyValueFromFunction(ArrayList<Double> inputFunction, double inputValue, String priceType){
        double fuzzyValue = 0.0;
        switch(priceType){
            case Constants.PRICE_CHEAP:
                if(inputValue >= inputFunction.get(0) && inputValue < inputFunction.get(1)){
                    fuzzyValue = 1.0;
                }
                else if(inputValue >= inputFunction.get(1) && inputValue <= inputFunction.get(2)){
                    fuzzyValue = (double)(inputFunction.get(2)-inputValue)/(inputFunction.get(2)-inputFunction.get(1));
                }
                break;
            case Constants.PRICE_NORMAL:
                if(inputValue >= inputFunction.get(0) && inputValue < inputFunction.get(1)){
                    fuzzyValue = (double)(inputValue - inputFunction.get(0))/(inputFunction.get(1)-inputFunction.get(0));
                }
                else if(inputValue >= inputFunction.get(1) && inputValue <= inputFunction.get(2)){
                    fuzzyValue = (double)(inputFunction.get(2)-inputValue)/(inputFunction.get(2)-inputFunction.get(1));
                }
                break;
            case Constants.PRICE_EXPENSIVE:
                if(inputValue >= inputFunction.get(0) && inputValue < inputFunction.get(1)){
                    fuzzyValue = (double)(inputValue - inputFunction.get(0))/(inputFunction.get(1)-inputFunction.get(0));
                }
                else if(inputValue >= inputFunction.get(1) && inputValue <= inputFunction.get(2)){
                    fuzzyValue = 1.0;
                }
                break;
        }
        return fuzzyValue;
    }
    
    // Function for rules' values calculation using fuzzy values of every dish price
    private ArrayList<Double> calculateRulesValues(ArrayList<Double> fuzzyValues){
        ArrayList<Double> rulesValues = new ArrayList<>();
         // There are 13 different rules, so loop from 1 to 13
         for (int i = 1; i <= 13; i++){
             // Calculates using minimum of all fuzzy values
             switch(i){
                // Coffe - Cheap, soup - NOT(Cheap), steak - Cheap
                // Result: Restaurant - Cheap
                case 1:
                    rulesValues.add(Math.min(Math.min(fuzzyValues.get(Constants.INDEX_COFFE_CHEAP), (1-fuzzyValues.get(Constants.INDEX_SOUP_CHEAP))), fuzzyValues.get(Constants.INDEX_STEAK_CHEAP)));
                    break;
                // Coffe - Normal, soup - NOT(Expensive), steak - Cheap
                // Result: Restaurant - Cheap
                case 2:
                    rulesValues.add(Math.min(Math.min(fuzzyValues.get(Constants.INDEX_COFFE_NORMAL), (1-fuzzyValues.get(Constants.INDEX_SOUP_EXPENSIVE))), fuzzyValues.get(Constants.INDEX_STEAK_CHEAP)));
                    break;
                // Coffe - NOT(Expensive), soup - Cheap, steak - Normal
                // Result: Restaurant - Cheap
                case 3:
                    rulesValues.add(Math.min(Math.min((1-fuzzyValues.get(Constants.INDEX_COFFE_EXPENSIVE)), fuzzyValues.get(Constants.INDEX_SOUP_CHEAP)), fuzzyValues.get(Constants.INDEX_STEAK_NORMAL)));
                    break;
                // Coffe - NOT(Normal), soup - Cheap, steak - Cheap
                // Result: Restaurant - Cheap
                case 4:
                    rulesValues.add(Math.min(Math.min((1-fuzzyValues.get(Constants.INDEX_COFFE_NORMAL)), fuzzyValues.get(Constants.INDEX_SOUP_CHEAP)), fuzzyValues.get(Constants.INDEX_STEAK_CHEAP)));
                    break;
                // Coffe - Cheap, soup - NOT(Expensive), steak - Expensive
                // Result: Restaurant - Affordable
                case 5:
                    rulesValues.add(Math.min(Math.min(fuzzyValues.get(Constants.INDEX_COFFE_CHEAP), (1-fuzzyValues.get(Constants.INDEX_SOUP_EXPENSIVE))), fuzzyValues.get(Constants.INDEX_STEAK_EXPENSIVE)));
                    break;
                // Coffe - Expensive, soup - Cheap, steak - NOT(Cheap)
                // Result: Restaurant - Affordable
                case 6:
                    rulesValues.add(Math.min(Math.min(fuzzyValues.get(Constants.INDEX_COFFE_EXPENSIVE), fuzzyValues.get(Constants.INDEX_SOUP_CHEAP)), (1-fuzzyValues.get(Constants.INDEX_STEAK_CHEAP))));
                    break;
                // Coffe - Expensive, soup - NOT(Cheap), steak - Cheap
                // Result: Restaurant - Affordable
                case 7:
                    rulesValues.add(Math.min(Math.min(fuzzyValues.get(Constants.INDEX_COFFE_EXPENSIVE), (1-fuzzyValues.get(Constants.INDEX_SOUP_CHEAP))), fuzzyValues.get(Constants.INDEX_STEAK_CHEAP)));
                    break;
                // Coffe - Normal, soup - Cheap, steak - Expensive
                // Result: Restaurant - Affordable
                case 8:
                    rulesValues.add(Math.min(Math.min(fuzzyValues.get(Constants.INDEX_COFFE_NORMAL), fuzzyValues.get(Constants.INDEX_SOUP_CHEAP)), fuzzyValues.get(Constants.INDEX_STEAK_EXPENSIVE)));
                    break;
                // Coffe - Normal, soup - Expensive, steak - NOT(Expensive)
                // Result: Restaurant - Affordable
                case 9:
                    rulesValues.add(Math.min(Math.min(fuzzyValues.get(Constants.INDEX_COFFE_NORMAL), fuzzyValues.get(Constants.INDEX_SOUP_EXPENSIVE)), (1-fuzzyValues.get(Constants.INDEX_STEAK_EXPENSIVE))));
                    break;
                // Coffe - NOT(Expensive), soup - Normal, steak - Normal
                // Result: Restaurant - Affordable
                case 10:
                    rulesValues.add(Math.min(Math.min((1-fuzzyValues.get(Constants.INDEX_COFFE_EXPENSIVE)), fuzzyValues.get(Constants.INDEX_SOUP_NORMAL)), fuzzyValues.get(Constants.INDEX_STEAK_NORMAL)));
                    break;
                // Coffe - Cheap, soup - Expensive, steak - NOT(Cheap)
                // Result: Restaurant - Luxurious
                case 11:
                    rulesValues.add(Math.min(Math.min(fuzzyValues.get(Constants.INDEX_COFFE_CHEAP), fuzzyValues.get(Constants.INDEX_SOUP_EXPENSIVE)), (1-fuzzyValues.get(Constants.INDEX_STEAK_CHEAP))));
                    break;
                // Coffe - Expensive, soup - NOT(Cheap), steak - NOT(Cheap)
                // Result: Restaurant - Luxurious
                case 12:
                    rulesValues.add(Math.min(Math.min(fuzzyValues.get(Constants.INDEX_COFFE_EXPENSIVE), (1-fuzzyValues.get(Constants.INDEX_SOUP_CHEAP))), (1-fuzzyValues.get(Constants.INDEX_STEAK_CHEAP))));
                    break;
                // Coffe - Normal, soup - NOT(Cheap), steak - Expensive
                // Result: Restaurant - Luxurious
                case 13:
                    rulesValues.add(Math.min(Math.min(fuzzyValues.get(Constants.INDEX_COFFE_NORMAL), (1-fuzzyValues.get(Constants.INDEX_SOUP_CHEAP))), fuzzyValues.get(Constants.INDEX_STEAK_EXPENSIVE)));
                    break;
             }
        }
        return rulesValues;
    }
    
    // Calculating function values necessary for output functions aggregation
    private ArrayList<Double> calculateAggregatedFunctionsValuesFromRules(ArrayList<Double> rulesValues){
        ArrayList<Double> aggregatedValues = new ArrayList<>();
        // 72---------------------------
        double aggregatedCheapValue = maxOfArrayList(rulesValues.subList(0, 4));
        double aggregatedAffordableValue = maxOfArrayList(rulesValues.subList(4, 10));
        double aggregatedLuxuriousValue = maxOfArrayList(rulesValues.subList(10, 13));
        //-------------------------------
        for (int i = 0; i <= 10; i++){
            if(i <= 2) 
                aggregatedValues.add(aggregatedCheapValue);
            else if(i == 3)
                aggregatedValues.add(aggregatedCheapValue >= aggregatedAffordableValue ? aggregatedCheapValue : aggregatedAffordableValue);
            else if(i >= 4 && i <= 6)
                aggregatedValues.add(aggregatedAffordableValue);
            else if(i == 7)
                aggregatedValues.add(aggregatedLuxuriousValue >= aggregatedAffordableValue ? aggregatedLuxuriousValue : aggregatedAffordableValue);
            else
                aggregatedValues.add(aggregatedLuxuriousValue);
        }
        return aggregatedValues;
    }
    
    // Function for finding the maximum value of list
    private double maxOfArrayList(List<Double> list){
        double currentMax = 0.0;
        for(Double d : list) currentMax = Math.max(currentMax, d);
        return currentMax;
    }
    
    // Function for calculation of output value using centroid method
    private double calculateOutputUsingCentroid(ArrayList<Double> outputValues){
        double numerator = 0.0;
        for(int i = 0; i <= 10; i++) numerator += i * outputValues.get(i);
        double denominator = 0.0;
        for(double d : outputValues) denominator += d;
        return (double)numerator/denominator;
    }
    
    // Function for output value verbalisation (converting output value to one of String values: "Cheap", "Affordable", "Luxurious" according to the calculated output value)
    private String verbalizeOutputValue(double outputValue){
        int outputIndex = 0;
        double maxValue = 0.0;
        for(int i = 0; i < outputFunctions.size(); i++){
            double fuzzyValue = 0.0;
            ArrayList<Double> function = outputFunctions.get(i);
            if(outputValue >= function.get(0) && outputValue < function.get(1)){
                fuzzyValue = (double)(outputValue - function.get(0))/(function.get(1)-function.get(0));
            }
            else if(outputValue >= function.get(1) && outputValue <= function.get(2)){
                fuzzyValue = (double)(function.get(2)-outputValue)/(function.get(2)-function.get(1));
            }
            if (fuzzyValue > maxValue){
                maxValue = fuzzyValue;
                outputIndex = i;
            }
        }
        return outputIndex == 0 ? Constants.RESTAURANT_CHEAP : outputIndex == 1 ? Constants.RESTAURANT_AFFORDABLE : Constants.RESTAURANT_LUXURIOUS;
    }
}