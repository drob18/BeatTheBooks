class LeagueStats
    @@GameStats2021
    def initialize()
        @OffStats = Hash.new([])
        @AdvStats = Hash.new([])
        @DefStats = Hash.new([])
    end

    
    # Hash consisting of a team name and an array, where the array contains 
    # [0]:W [1]:L [2]:SRS [3]:ORtg [4]:DRtg [5]:NRtg
    # [6]:Pace [7]:eFG% [8]:TOV% [9]:ORB% [10]:FT/FGA	
    # [11]:eFG%	[12]:TOV% [13]:DRB% [14]:FT/FGA
																				
    def loadAdv(file)
        f = File.new(file, "r")
        lines = f.readlines
        lines.each{ |line|
            arr = line.split(" ")
            team = arr.shift()
            @AdvStats[team] = []
            arr.each do |x|
                @AdvStats[team].push(x.to_f)
            end
        }
        @AdvStats
    end



    def getStat(team, stat)
        case stat
        when "W"
            @AdvStats[team][0]
        when "L"
            @AdvStats[team][1]
        when "SRS"
            @AdvStats[team][2]
        when "ORTG"
            @AdvStats[team][3]
        when "DRTG"
            @AdvStats[team][4]
        when "NRTG"
            @AdvStats[team][5]
        when "PACE"
            @AdvStats[team][6]
        when "TEAMEFG"
            @AdvStats[team][7]
        when "TEAMTOV"
            @AdvStats[team][8]
        when "TEAMORB"
            @AdvStats[team][9]
        when "TEAMFTFGA"
            @AdvStats[team][10]
        when "OPPEFG"
            @AdvStats[team][11]
        when "OPPTOV"
            @AdvStats[team][12]
        when "OPPDRB"
            @AdvStats[team][13]
        when "OPPFTFGA"
            @AdvStats[team][14]
        else
            "Not found"
        end
    end

    def compWinPer(team1,team2)
        if team1 == team2 
            "Same Team"
        else
            winPer1 = (@AdvStats[team1][0])/(@AdvStats[team1][0]+@AdvStats[team1][1])
            winPer2 = (@AdvStats[team2][0])/(@AdvStats[team2][0]+@AdvStats[team2][1])
            if winPer1 > winPer2
                team1
            elsif winPer1 < winPer2
                team2
            else
                "Same Percentage"
            end
        end
    end

    def findScore1(team1,team2)
        if @AdvStats.has_key?(team1) && @AdvStats.has_key?(team2)
            avPoss = Math.sqrt(@AdvStats[team1][6] * @AdvStats[team2][6])
            stPoss = avPoss/100
            Math.sqrt(@AdvStats[team1][3] * @AdvStats[team2][4]) * stPoss
        else
            "Not A Team"
        end
    end

    def findScore2(team1,team2)
        if @AdvStats.has_key?(team1) && @AdvStats.has_key?(team2)
            avPoss = (@AdvStats[team1][6] + @AdvStats[team2][6])/2
            stPoss = avPoss/100
            ((@AdvStats[team2][3] + @AdvStats[team1][4])/2) * stPoss
        else
            "Wrong Teams"
        end
    end

    def findOverUnder(team1,team2)
        if @AdvStats.has_key?(team1) && @AdvStats.has_key?(team2)
            findScore1(team1,team2) + findScore2(team1,team2)
        else
            "Not a real team"
        end
    end

    def findWinnerSpread(team1,team2)
        if @AdvStats.has_key?(team1) && @AdvStats.has_key?(team2)
            if findScore1(team1,team2) > findScore2(team1,team2)
                sp = findScore1(team1,team2) - findScore2(team1,team2) 
                total = findScore2(team1,team2) + findScore1(team1,team2) 
                puts(team1 + " -" +sp.round(3).to_s+ " O/U: " +total.round(3).to_s)
                total
            else
                sp = findScore2(team1,team2) - findScore1(team1,team2) 
                total = findScore2(team1,team2) + findScore1(team1,team2) 
                puts(team2 + " -" +sp.round(3).to_s+ " O/U: " +total.round(3).to_s)
                total
            end
        else
            0
        end
    end

    def loadMatchups(file)
        f = File.new(file, "r")
        lines = f.readlines
        lines.each{ |line|
            arr = line.split(" ")
            if @AdvStats.has_key?(arr[0]) && @AdvStats.has_key?(arr[1])
                found = findWinnerSpread(arr[0],arr[1])
                puts(overUnder(found,arr[2].to_f))
            end
        }
    end

    def overUnder(found,vegas)
        if found > vegas then 
            "Over " + vegas.to_s + " by " +((found-vegas).round(2)).to_s
        else 
            "Under " + vegas.to_s + " by " +((vegas-found).round(2)).to_s
        end
    end

    def insertAdj(file)
        f = File.new(file, "r")
        lines = f.readlines
        lines.each{ |line|
            arr = line.split(" ")
            if @AdvStats.has_key?(arr[0]) 
                @AdvStats[arr[0]][3] = arr[1].to_f
                @AdvStats[arr[0]][4] = arr[2].to_f
                @AdvStats[arr[0]][5] = arr[3].to_f
            end
        }
    end




    s20 = LeagueStats.new()
    puts("2020")
    s20.loadAdv("AdvMetrics20.txt")
    s20.loadMatchups("Games.txt")
    puts("2021")
    s21 = LeagueStats.new()
    s21.loadAdv("AdvMetrics21.txt")
    s21.insertAdj("AdjRtg21.txt")
    s21.loadMatchups("Games.txt")
    
end
    