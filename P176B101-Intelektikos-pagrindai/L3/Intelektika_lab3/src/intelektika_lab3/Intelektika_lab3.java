package intelektika_lab3;

import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Scanner;
import java.util.regex.Pattern;

public class Intelektika_lab3 {
    private static final File SPAM_DIRECTORY = new File("Training_data/Spam");
    private static final File NOT_SPAM_DIRECTORY = new File("Training_data/NotSpam");
    private static final File TESTING_SPAM_DIRECTORY = new File("Testing_data/Spam");
    private static final File TESTING_NOT_SPAM_DIRECTORY = new File("Testing_data/NotSpam");
    private static final File ANALYSE_SPAM_DIRECTORY = new File("Analyse_data/Spam");
    private static final File ANALYSE_NOT_SPAM_DIRECTORY = new File("Analyse_data/NotSpam");
    private static final Pattern REGEX = Pattern.compile("[^a-zA-Z0-9$'\"]");
    private static int spamTokensCounter = 0;
    private static int notSpamTokensCounter = 0;
    private static int correctAnalyseFiles;
    
    private static class Token{
        private int spamCounter;
        private int notSpamCounter;
        private double spamProbability;
        private double notSpamProbability;
        private double probability;
        
        public Token(){
            this.spamCounter = 0;
            this.notSpamCounter = 0;
            this.probability = 0.0;
            this.spamProbability = 0.0;
            this.notSpamProbability = 0.0;
        }
        
        public Token(double probability){
            this.spamCounter = 0;
            this.notSpamCounter = 0;
            this.probability = probability;
            this.spamProbability = 0.0;
            this.notSpamProbability = 0.0;
        }
        
        public void incSpamCounter(){
            this.spamCounter++;
        }
        
        public void incNotSpamCounter(){
            this.notSpamCounter++;
        }
        
        public void setProbability(double probability){
            this.probability = probability;
        }
        
        public void setSpamProbability(double probability){
            this.spamProbability = probability;
        }
        
        public void setNotSpamProbability(double probability){
            this.notSpamProbability = probability;
        }
        
        public int getSpamCounter(){
            return this.spamCounter;
        }
        
        public int getNotSpamCounter(){
            return this.notSpamCounter;
        }
        
        public double getProbability(){
            return this.probability;
        }
        
        public double getSpamProbability(){
            return this.spamProbability;
        }
        
        public double getNotSpamProbability(){
            return this.notSpamProbability;
        }
    }
        
    private static void readTokensFromFiles(Map<String, Token> tokens){
        String word;
        for (File file : SPAM_DIRECTORY.listFiles()){
            try (Scanner scanner = new Scanner(file)) {
                while (scanner.hasNext()){
                    scanner.useDelimiter(REGEX);
                    word = scanner.next();
                    word = word.toLowerCase();
                    if (!word.equals("")){
                        if(tokens.containsKey(word)){
                            Token token = tokens.get(word);
                            token.incSpamCounter();
                            tokens.put(word, token);
                        }
                        else{
                            Token token = new Token();
                            token.incSpamCounter();
                            tokens.put(word, token);
                            spamTokensCounter++;
                        }
                    }
                }
            } catch (Exception ex) {
                System.out.println(ex);
                System.exit(1);
            }
        }
        for (File file : NOT_SPAM_DIRECTORY.listFiles()){
            try (Scanner scanner = new Scanner(file)) {
                while (scanner.hasNext()){
                    scanner.useDelimiter(REGEX);
                    word = scanner.next();
                    word = word.toLowerCase();
                    if (!word.equals("")){
                        if(tokens.containsKey(word)){
                            Token token = tokens.get(word);
                            token.incNotSpamCounter();
                            tokens.put(word, token);
                        }
                        else{
                            Token token = new Token();
                            token.incNotSpamCounter();
                            tokens.put(word, token);
                            notSpamTokensCounter++;
                        }
                    }
                }
            } catch (Exception ex) {
                System.out.println(ex);
                System.exit(1);
            }
        }
    }
    
    private static void analyseFile(Map<String, Token> tokens, Map<String, Double> probabilities, File file){
        String word;
        try (Scanner scanner = new Scanner(file)) {
            while (scanner.hasNext()){
                scanner.useDelimiter(REGEX);
                word = scanner.next();
                word = word.toLowerCase();
                if (!word.equals("")){
                    if(tokens.containsKey(word)){
                        Token token = tokens.get(word);
                        probabilities.put(word, token.getProbability());
                    }
                    else{
                        probabilities.put(word, 0.4);
                    }
                }
            }
        } catch (Exception ex) {
            System.out.println(ex);
            System.exit(1);
        }
    }
    
    private static void calculateTestingFilesProbabilities(Map<String, Token> tokens, List<Double> spamFilesProbabilities, List<Double> notSpamFilesProbabilities, int testingTokensCount){
        for (File file : TESTING_SPAM_DIRECTORY.listFiles()){            
            Map<String, Double> newFileProbabilities = new HashMap<>();
            analyseFile(tokens, newFileProbabilities, file);
            Map<String, Double> sortedMap = sortMapByValue(newFileProbabilities);
            spamFilesProbabilities.add(calculateFileSpamProbability(sortedMap, testingTokensCount));
        }
        Collections.sort(spamFilesProbabilities);
        Collections.reverse(spamFilesProbabilities);
        for (File file : TESTING_NOT_SPAM_DIRECTORY.listFiles()){
            Map<String, Double> newFileProbabilities = new HashMap<>();
            analyseFile(tokens, newFileProbabilities, file);
            Map<String, Double> sortedMap = sortMapByValue(newFileProbabilities);
            notSpamFilesProbabilities.add(calculateFileSpamProbability(sortedMap, testingTokensCount));
        }
        Collections.sort(notSpamFilesProbabilities);
        Collections.reverse(notSpamFilesProbabilities);
    }
    
    private static void calculateAnalyseFilesProbabilities(Map<String, Token> tokens, List<Double> spamFilesProbabilities, List<Double> notSpamFilesProbabilities, int testingTokensCount){
        for (File file : ANALYSE_SPAM_DIRECTORY.listFiles()){            
            Map<String, Double> newFileProbabilities = new HashMap<>();
            analyseFile(tokens, newFileProbabilities, file);
            Map<String, Double> sortedMap = sortMapByValue(newFileProbabilities);
            spamFilesProbabilities.add(calculateFileSpamProbability(sortedMap, testingTokensCount));
        }
        Collections.sort(spamFilesProbabilities);
        Collections.reverse(spamFilesProbabilities);
        for (File file : ANALYSE_NOT_SPAM_DIRECTORY.listFiles()){
            Map<String, Double> newFileProbabilities = new HashMap<>();
            analyseFile(tokens, newFileProbabilities, file);
            Map<String, Double> sortedMap = sortMapByValue(newFileProbabilities);
            notSpamFilesProbabilities.add(calculateFileSpamProbability(sortedMap, testingTokensCount));
        }
        Collections.sort(notSpamFilesProbabilities);
        Collections.reverse(notSpamFilesProbabilities);
    }
    
    private static void calculateTokensProbabilities(Map<String, Token> tokens){
        tokens.forEach((t, u) -> {
           double pws = (u.getSpamCounter() == 0) ? 0 : (double)u.getSpamCounter()/spamTokensCounter;
           double pwh = (u.getNotSpamCounter() == 0) ? 0 : (double)u.getNotSpamCounter()/notSpamTokensCounter;
           u.setSpamProbability(pws);
           u.setNotSpamProbability(pwh);
           if (pws == 0 && pwh > 0){
               u.setProbability(0.01);
           }
           else if(pws > 0 && pwh == 0){
               u.setProbability(0.99);
           }
           else{
               u.setProbability((double)(pws/(pws + pwh)));
           }
        });
    }
    
    private static double calculateFileSpamProbability(Map<String, Double> tokens, int testingTokensCount){
        double numerator = 1;
        double denominatorSubstraction = 1;
        if(tokens.size() >= testingTokensCount){
            List<Map.Entry<String, Double>> list =
                new LinkedList<>(tokens.entrySet());
            testingTokensCount /= 2;
            for (int i = 0; i < testingTokensCount; i++){
                numerator *= list.get(i).getValue();
                denominatorSubstraction *= 1 - list.get(i).getValue();
            }
            for (int i = list.size()-1; i > list.size() - (testingTokensCount + 1); i--){
                numerator *= list.get(i).getValue();
                denominatorSubstraction *= 1 - list.get(i).getValue();
            }
        }
        else{
            for(Map.Entry<String, Double> entry : tokens.entrySet()){
                numerator *= entry.getValue();
                denominatorSubstraction *= 1 - entry.getValue();
            }
        }
        return (double)numerator/(numerator + denominatorSubstraction);
    }
    
    private static <K, V> void printMap(Map<K, V> map) {
        for (Map.Entry<K, V> entry : map.entrySet()) {
            System.out.println("Key : " + entry.getKey()
                    + "; Value : " + entry.getValue());
        }
    }
    
    private static <K, V extends Comparable<? super V>> Map<K, V> sortMapByValue(Map<K, V> unsortMap) {
        List<Map.Entry<K, V>> list =
                new LinkedList<>(unsortMap.entrySet());

        Collections.sort(list, (Map.Entry<K, V> o1, Map.Entry<K, V> o2) -> (o1.getValue()).compareTo(o2.getValue()));

        Map<K, V> result = new LinkedHashMap<>();
        list.forEach((entry) -> {
            result.put(entry.getKey(), entry.getValue());
        });
        return result;
    }
    
    private static double calculateThreshold(List<Double> notSpamFilesProbabilities){
        return (double)Math.ceil(notSpamFilesProbabilities.get(0) * 100)/100;
    }
    
    private static double calculateTrueOrFalsePositiveFilesPercentage(List<Double> filesProbabilities, double threshold){
        int counter = 0;
        for (double i : filesProbabilities) if(i > threshold) counter++;
        return (double)Math.round((double)counter/filesProbabilities.size()*10000)/100;
    }
    
    private static void calculateThresholdsWithDifferentTokensCount(Map<Integer, Double> thresholds){
        int[] tokenCounts = {2, 4, 8, 12, 16, 24, 32};
        System.out.println("Learning... ");
        Map<String, Token> tokens = new HashMap<>();
        readTokensFromFiles(tokens);
        calculateTokensProbabilities(tokens);
        for (int i : tokenCounts){
            List<Double> spamFilesProbabilities = new ArrayList<>();
            List<Double> notSpamFilesProbabilities = new ArrayList<>();
            List<Double> spamAnalyseFilesProbabilities = new ArrayList<>();
            List<Double> notSpamAnalyseFilesProbabilities = new ArrayList<>();
            System.out.println("Testing... ");
            calculateTestingFilesProbabilities(tokens, spamFilesProbabilities, notSpamFilesProbabilities, i);
            System.out.println("Tokens count: " + i);
            double threshold = calculateThreshold(notSpamFilesProbabilities);
            System.out.println("Threshold value: " + threshold);
            System.out.println("Analysing... ");
            calculateAnalyseFilesProbabilities(tokens, spamAnalyseFilesProbabilities, notSpamAnalyseFilesProbabilities, i);
            double truePositiveSpamFilesPercentage = calculateTrueOrFalsePositiveFilesPercentage(spamAnalyseFilesProbabilities, threshold);
            double falsePositiveSpamFilesPercentage = calculateTrueOrFalsePositiveFilesPercentage(notSpamAnalyseFilesProbabilities, threshold);
            System.out.println("True positive files percentage: " + truePositiveSpamFilesPercentage + "%");
            System.out.println("False positive files percentage: " + falsePositiveSpamFilesPercentage + "%");
            System.out.println("Analysed files probabilities and their status (SPAM or NOT SPAM):");
            System.out.println("Files from SPAM directory:");
            correctAnalyseFiles = 0;
            for(double j : spamAnalyseFilesProbabilities){
                System.out.println(j + " " + (j > threshold ? "SPAM" : "NOT SPAM"));
                if (j > threshold) correctAnalyseFiles++;
            }
            System.out.println();
            System.out.println("Files from NOT SPAM directory:");
            for(double j : notSpamAnalyseFilesProbabilities){
                System.out.println(j + " " + (j > threshold ? "SPAM" : "NOT SPAM"));
                if (j <= threshold) correctAnalyseFiles++;
            }
            System.out.println("Bendras programos tikslumas:" + (double)Math.round((double)correctAnalyseFiles/(spamFilesProbabilities.size() + notSpamFilesProbabilities.size())*10000)/100 + "%");
            System.out.println("-----------------------------------------------");
        }
    }
    
    public static void main(String[] args) {
        Map<Integer, Double> thresholds = new HashMap<>();
        calculateThresholdsWithDifferentTokensCount(thresholds);
    }
}