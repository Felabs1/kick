import React, { useState, useEffect } from 'react';
import { Trophy, Users, TrendingUp, Briefcase } from 'lucide-react';

interface PersonalInfo {
  name: string;
  age: number;
  nationality: string;
}

interface ManagerialSkills {
  tacticalAbility: number;
  playerManagement: number;
  youngPlayerDevelopment: number;
  motivationAbility: number;
  disciplineManagement: number;
  financialManagement: number;
  mediaHandling: number;
}

interface CareerStats {
  experience: number;
  reputation: number;
  managedTeams: number[];
  trophiesWon: number[];
  totalMatchesManaged: number;
  totalWins: number;
  totalDraws: number;
  totalLosses: number;
}

interface ManagerStyle {
  preferredFormations: string[];
  preferredPlayingStyle: string;
  specialties: string[];
}

interface FinancialInfo {
  lastContractValue: number;
  careerEarnings: number;
}

interface Manager {
  personalInfo: PersonalInfo;
  skills: ManagerialSkills;
  careerStats: CareerStats;
  style: ManagerStyle;
  financials: FinancialInfo;
  lastSeasonPerformance: number;
  profileImage: string; // New field for profile image
}

const ManagersView: React.FC = () => {
  const [manager, setManager] = useState<Manager | null>(null);

  useEffect(() => {
    // Simulating fetching manager data
    const fetchManagerData = async () => {
      // In a real application, this would come from your Web3 connection or API
      const mockManagerData: Manager = {
        personalInfo: {
          name: "John Doe",
          age: 45,
          nationality: "English"
        },
        skills: {
          tacticalAbility: 80,
          playerManagement: 75,
          youngPlayerDevelopment: 70,
          motivationAbility: 85,
          disciplineManagement: 78,
          financialManagement: 65,
          mediaHandling: 72
        },
        careerStats: {
          experience: 15,
          reputation: 82,
          managedTeams: [1, 3, 7],
          trophiesWon: [2, 5, 8],
          totalMatchesManaged: 500,
          totalWins: 250,
          totalDraws: 150,
          totalLosses: 100
        },
        style: {
          preferredFormations: ["4-3-3", "4-2-3-1"],
          preferredPlayingStyle: "Possession-based",
          specialties: ["Youth Development", "Tactical Flexibility"]
        },
        financials: {
          lastContractValue: 5000000,
          careerEarnings: 50000000
        },
        lastSeasonPerformance: 85,
        profileImage: "/manager.png" // Placeholder image
      };
      setManager(mockManagerData);
    };

    fetchManagerData();
  }, []);

  if (!manager) {
    return <div>Loading manager data...</div>;
  }

  return (
    <>
      <section className="mb-12">
        <h3 className="text-2xl font-semibold mb-4">Manager Overview</h3>
        <div className="bg-white bg-opacity-10 p-6 rounded-lg flex flex-col md:flex-row items-center md:items-start">
          <img 
            src={manager.profileImage} 
            alt={manager.personalInfo.name} 
            className="w-40 h-40 mb-4 md:mb-0 md:mr-6"
          />
          <div className="flex-grow">
            <p className="text-xl mb-2"><span className="font-semibold">Name:</span> {manager.personalInfo.name}</p>
            <p className="text-xl mb-2"><span className="font-semibold">Age:</span> {manager.personalInfo.age}</p>
            <p className="text-xl mb-2"><span className="font-semibold">Nationality:</span> {manager.personalInfo.nationality}</p>
            <p className="text-xl mb-2"><span className="font-semibold">Experience:</span> {manager.careerStats.experience} years</p>
            <p className="text-xl mb-4"><span className="font-semibold">Reputation:</span> {manager.careerStats.reputation}/100</p>
            <button className="bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600 transition-colors">View Full Profile</button>
          </div>
        </div>
      </section>

      <section className="grid grid-cols-1 md:grid-cols-3 gap-8 mb-12">
        <div className="bg-white bg-opacity-10 p-6 rounded-lg flex items-center">
          <Trophy className="mr-4" size={32} />
          <div>
            <h3 className="font-semibold">Trophies</h3>
            <p>{manager.careerStats.trophiesWon.length} Won</p>
          </div>
        </div>
        <div className="bg-white bg-opacity-10 p-6 rounded-lg flex items-center">
          <Users className="mr-4" size={32} />
          <div>
            <h3 className="font-semibold">Teams Managed</h3>
            <p>{manager.careerStats.managedTeams.length} Teams</p>
          </div>
        </div>
        <div className="bg-white bg-opacity-10 p-6 rounded-lg flex items-center">
          <TrendingUp className="mr-4" size={32} />
          <div>
            <h3 className="font-semibold">Win Rate</h3>
            <p>{((manager.careerStats.totalWins / manager.careerStats.totalMatchesManaged) * 100).toFixed(2)}%</p>
          </div>
        </div>
      </section>

      <section className="mb-12">
        <h3 className="text-2xl font-semibold mb-4">Managerial Skills</h3>
        <div className="bg-white bg-opacity-10 p-6 rounded-lg grid grid-cols-2 md:grid-cols-3 gap-4">
          {Object.entries(manager.skills).map(([skill, value]) => (
            <div key={skill} className="flex items-center">
              <div className="w-full bg-gray-200 rounded-full h-2.5 mr-2">
                <div className="bg-green-600 h-2.5 rounded-full" style={{ width: `${value}%` }}></div>
              </div>
              <span className="text-sm whitespace-nowrap">{skill.replace(/([A-Z])/g, ' $1').trim()}: {value}</span>
            </div>
          ))}
        </div>
      </section>

      <section>
        <h3 className="text-2xl font-semibold mb-4">Manager Style</h3>
        <div className="bg-white bg-opacity-10 p-6 rounded-lg">
          <p className="text-xl mb-4">Preferred Formations: {manager.style.preferredFormations.join(", ")}</p>
          <p className="text-xl mb-4">Playing Style: {manager.style.preferredPlayingStyle}</p>
          <p className="text-xl mb-4">Specialties: {manager.style.specialties.join(", ")}</p>
        </div>
      </section>
    </>
  );
};

export default ManagersView;