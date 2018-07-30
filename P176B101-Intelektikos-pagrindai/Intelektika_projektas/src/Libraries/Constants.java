package Libraries;

import java.util.ArrayList;

public class Constants {
    // General constants
    public static final int ASKING_TIME = 500;
    public static final int ASKING_TIME_TOURIST = 9 * ASKING_TIME;
    public static final String NAME_AGENT_A = "AgentA";
    public static final String NAME_AGENT_V = "AgentV";
    public static final String NAME_AGENT_SP = "AgentSP";
    public static final String AGENTS_PACK = "Agents";
    
    // Coffee constants
    public static final Double COFFEE_CHEAP_MIN = 1.5;
    public static final Double COFFEE_CHEAP_MAX = 2.5;
    public static final Double COFFEE_NORMAL_MIN = 2.0;
    public static final Double COFFEE_NORMAL_MAX = 3.0;
    public static final Double COFFEE_EXPENSIVE_MIN = 2.5; 
    public static final Double COFFEE_EXPENSIVE_MAX = 3.5;
    
    // Soup constants
    public static final Double SOUP_CHEAP_MIN = 2.0;
    public static final Double SOUP_CHEAP_MAX = 3.5;
    public static final Double SOUP_NORMAL_MIN = 3.0;
    public static final Double SOUP_NORMAL_MAX = 4.5;
    public static final Double SOUP_EXPENSIVE_MIN = 4.0; 
    public static final Double SOUP_EXPENSIVE_MAX = 5.5;
    
    // Stake constants
    public static final Double STEAK_CHEAP_MIN = 5.0;
    public static final Double STEAK_CHEAP_MAX = 12.0;
    public static final Double STEAK_NORMAL_MIN = 8.0;
    public static final Double STEAK_NORMAL_MAX = 15.0;
    public static final Double STEAK_EXPENSIVE_MIN = 13.0; 
    public static final Double STEAK_EXPENSIVE_MAX = 20.0;
    
    // Output functions constants
    public static final Double OUTPUT_CHEAP_MIN = 0.0;
    public static final Double OUTPUT_CHEAP_MAX = 4.0;
    public static final Double OUTPUT_AFFORDABLE_MIN = 2.0;
    public static final Double OUTPUT_AFFORDABLE_MAX = 8.0;
    public static final Double OUTPUT_LUXURIOUS_MIN = 6.0;
    public static final Double OUTPUT_LUXURIOUS_MAX = 10.0;
    
    // Fuzzy values indexes
    public static final int INDEX_COFFE_CHEAP = 0;
    public static final int INDEX_COFFE_NORMAL = 1;
    public static final int INDEX_COFFE_EXPENSIVE = 2;
    public static final int INDEX_SOUP_CHEAP = 3;
    public static final int INDEX_SOUP_NORMAL = 4;
    public static final int INDEX_SOUP_EXPENSIVE = 5;
    public static final int INDEX_STEAK_CHEAP = 6;
    public static final int INDEX_STEAK_NORMAL = 7;
    public static final int INDEX_STEAK_EXPENSIVE = 8;
    
    // Price types
    public static final String PRICE_CHEAP = "Cheap";
    public static final String PRICE_NORMAL = "Normal";
    public static final String PRICE_EXPENSIVE = "Expensive";
    
    // Restaurant states
    public static final String RESTAURANT_CHEAP = "Cheap";
    public static final String RESTAURANT_AFFORDABLE = "Affordable";
    public static final String RESTAURANT_LUXURIOUS = "Luxurious";
    
    // Function to get dishes price ranges values array
    public static ArrayList<Double> constantsToArray(){
        ArrayList<Double> constants = new ArrayList<>();
        constants.add(COFFEE_CHEAP_MIN);
        constants.add(COFFEE_CHEAP_MAX);
        constants.add(COFFEE_NORMAL_MIN);
        constants.add(COFFEE_NORMAL_MAX);
        constants.add(COFFEE_EXPENSIVE_MIN);
        constants.add(COFFEE_EXPENSIVE_MAX);
        constants.add(SOUP_CHEAP_MIN);
        constants.add(SOUP_CHEAP_MAX);
        constants.add(SOUP_NORMAL_MIN);
        constants.add(SOUP_NORMAL_MAX);
        constants.add(SOUP_EXPENSIVE_MIN);
        constants.add(SOUP_EXPENSIVE_MAX);
        constants.add(STEAK_CHEAP_MIN);
        constants.add(STEAK_CHEAP_MAX);
        constants.add(STEAK_NORMAL_MIN);
        constants.add(STEAK_NORMAL_MAX);
        constants.add(STEAK_EXPENSIVE_MIN);
        constants.add(STEAK_EXPENSIVE_MAX);
        return constants;
    }
}