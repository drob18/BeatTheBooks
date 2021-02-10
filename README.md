# BeatTheBooks

This is a repository made to try and beat the sports betting lines created by Vegas. Attempts to use predictive modeling to get outcomes of NBA games.

Takes input via an excel sheet created from www.basketball-reference.com data. Uses offensive and defensive efficiency to predict a score for the games in Games.txt and outputs to STDout. Holds the data in a hash, with each entry representing a team, and the value being an array that holds the data. The algorithm extracts by indexing the array to get the desired statistics and then computing spreads and totals. These spreads and totals are then compared against the linemakers in another excel.

Parses the input by splitting up the spaces and accessing in the array. Holds teams as a distinct 3 character name in the hash.
