import React, { useState, useEffect } from 'react';
import { Trophy, Users, TrendingUp, Briefcase, AlertCircle } from 'lucide-react';
import AddManagerModal from './AddManager'


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
  const [isModalOpen, setIsModalOpen] = useState(false);


  useEffect(() => {
    // Simulating fetching manager data
    const fetchManagerData = async () => {
      // // In a real application, this would come from your Web3 connection or API
      // const mockManagerData: Manager = {
      //   personalInfo: {
      //     name: "John Doe",
      //     age: 45,
      //     nationality: "English"
      //   },
      //   skills: {
      //     tacticalAbility: 80,
      //     playerManagement: 75,
      //     youngPlayerDevelopment: 70,
      //     motivationAbility: 85,
      //     disciplineManagement: 78,
      //     financialManagement: 65,
      //     mediaHandling: 72
      //   },
      //   careerStats: {
      //     experience: 15,
      //     reputation: 82,
      //     managedTeams: [1, 3, 7],
      //     trophiesWon: [2, 5, 8],
      //     totalMatchesManaged: 500,
      //     totalWins: 250,
      //     totalDraws: 150,
      //     totalLosses: 100
      //   },
      //   style: {
      //     preferredFormations: ["4-3-3", "4-2-3-1"],
      //     preferredPlayingStyle: "Possession-based",
      //     specialties: ["Youth Development", "Tactical Flexibility"]
      //   },
      //   financials: {
      //     lastContractValue: 5000000,
      //     careerEarnings: 50000000
      //   },
      //   lastSeasonPerformance: 85,
      //   profileImage: "/manager.png" // Placeholder image
      // };
      // setManager(mockManagerData);
    };

    fetchManagerData();
  }, []);


  const handleAddManager = (managerData: any) => {
    // Here you would call your contract method to add the manager
    console.log('Adding manager:', managerData);
    // You might want to update your managers list or refetch data here
  };

  if (!manager) {
    return (
      <div className="w-full h-96 flex items-center justify-center bg-gradient-to-br from-gray-900 to-gray-800 rounded-lg shadow-xl">
        <div className="text-center p-6">
          <AlertCircle className="w-16 h-16 mx-auto mb-4 text-yellow-500" />
          <h2 className="text-2xl font-bold mb-2 text-white">No Manager Assigned</h2>
          <p className="text-gray-400">You haven't joined as a manager yet.</p>
          <div>
          <button className="bg-cyan-500 hover:bg-cyan-700 text-white font-bold py-2 px-4 rounded" onClick={() => setIsModalOpen(true)}>Join</button>
          <AddManagerModal
            isOpen={isModalOpen}
            onClose={() => setIsModalOpen(false)}
            onAddManager={handleAddManager}
          />
        </div>
        </div>

      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="bg-gradient-to-br from-gray-900 to-gray-800 rounded-lg shadow-xl p-6">
        <div className="flex flex-col md:flex-row items-center md:items-start space-y-4 md:space-y-0 md:space-x-6">
          <img 
            src={manager.profileImage} 
            alt={manager.personalInfo.name} 
            className="w-32 h-32 rounded-full border-4 border-green-500 shadow-lg"
          />
          <div className="flex-grow">
            <h2 className="text-3xl font-bold mb-2 text-white">{manager.personalInfo.name}</h2>
            <div className="flex flex-wrap gap-2 mb-4">
              {[manager.personalInfo.nationality, `${manager.personalInfo.age} years old`, `${manager.careerStats.experience} years exp.`].map((item, index) => (
                <span key={index} className="px-2 py-1 bg-gray-700 text-white rounded-full text-sm">{item}</span>
              ))}
            </div>
            <div className="flex items-center space-x-2">
              <span className="text-sm font-medium text-white">Reputation</span>
              <div className="w-64 bg-gray-700 rounded-full h-2.5">
                <div 
                  className="bg-green-600 h-2.5 rounded-full" 
                  style={{ width: `${manager.careerStats.reputation}%` }}
                ></div>
              </div>
              <span className="text-sm font-medium text-white">{manager.careerStats.reputation}/100</span>
            </div>
          </div>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        {[
          { title: "Trophies Won", value: manager.careerStats.trophiesWon.length, icon: Trophy, color: "from-green-600 to-green-700" },
          { title: "Teams Managed", value: manager.careerStats.managedTeams.length, icon: Users, color: "from-blue-600 to-blue-700" },
          { title: "Win Rate", value: `${((manager.careerStats.totalWins / manager.careerStats.totalMatchesManaged) * 100).toFixed(0)}%`, icon: TrendingUp, color: "from-purple-600 to-purple-700" }
        ].map((item, index) => (
          <div key={index} className={`bg-gradient-to-br ${item.color} text-white rounded-lg shadow-xl p-6`}>
            <div className="flex items-center space-x-4">
              <item.icon className="w-12 h-12" />
              <div>
                <p className="text-lg font-semibold">{item.title}</p>
                <p className="text-3xl font-bold">{item.value}</p>
              </div>
            </div>
          </div>
        ))}
      </div>

      <div className="bg-white bg-opacity-10 rounded-lg shadow-xl p-6">
        <h3 className="text-xl font-bold mb-4 text-white">Managerial Skills</h3>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          {Object.entries(manager.skills).map(([skill, value]) => (
            <div key={skill} className="space-y-2">
              <div className="flex justify-between items-center">
                <span className="text-sm font-medium text-white">{skill.replace(/([A-Z])/g, ' $1').trim()}</span>
                <span className="text-sm font-medium text-white">{value}/100</span>
              </div>
              <div className="w-full bg-gray-700 rounded-full h-2.5">
                <div 
                  className="bg-green-600 h-2.5 rounded-full" 
                  style={{ width: `${value}%` }}
                ></div>
              </div>
            </div>
          ))}
        </div>
      </div>

      <div className="bg-white bg-opacity-10 rounded-lg shadow-xl p-6">
        <h3 className="text-xl font-bold mb-4 text-white">Manager Style</h3>
        <div className="space-y-4">
          <div>
            <p className="text-sm font-medium mb-2 text-white">Preferred Formations</p>
            <div className="flex flex-wrap gap-2">
              {manager.style.preferredFormations.map((formation, index) => (
                <span key={index} className="px-2 py-1 bg-gray-700 text-white rounded-full text-sm">{formation}</span>
              ))}
            </div>
          </div>
          <div>
            <p className="text-sm font-medium mb-2 text-white">Playing Style</p>
            <span className="px-2 py-1 bg-gray-700 text-white rounded-full text-sm">{manager.style.preferredPlayingStyle}</span>
          </div>
          <div>
            <p className="text-sm font-medium mb-2 text-white">Specialties</p>
            <div className="flex flex-wrap gap-2">
              {manager.style.specialties.map((specialty, index) => (
                <span key={index} className="px-2 py-1 bg-gray-700 text-white rounded-full text-sm">{specialty}</span>
              ))}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ManagersView;