import React, { useState } from 'react';
import { X } from 'lucide-react';

interface AddManagerModalProps {
  isOpen: boolean;
  onClose: () => void;
  onAddManager: (managerData: any) => void;
}

const AddManagerModal: React.FC<AddManagerModalProps> = ({ isOpen, onClose, onAddManager }) => {
  const [name, setName] = useState('');
  const [age, setAge] = useState('');
  const [nationality, setNationality] = useState('');
  const [experience, setExperience] = useState('');
  const [preferredFormations, setPreferredFormations] = useState('');
  const [preferredPlayingStyle, setPreferredPlayingStyle] = useState('');
  const [specialties, setSpecialties] = useState('');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    const managerData = {
      name,
      age: parseInt(age),
      nationality,
      experience: parseInt(experience),
      preferredFormations: preferredFormations.split(',').map(item => item.trim()),
      preferredPlayingStyle,
      specialties: specialties.split(',').map(item => item.trim())
    };
    onAddManager(managerData);
    onClose();
  };

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center p-4">
      <div className="bg-gray-800 rounded-lg p-6 w-full max-w-2xl">
        <div className="flex justify-between items-center mb-6">
          <h2 className="text-2xl font-bold text-white">Add New Manager</h2>
          <button onClick={onClose} className="text-gray-400 hover:text-white">
            <X size={24} />
          </button>
        </div>
        <form onSubmit={handleSubmit} className="space-y-6">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label htmlFor="name" className="block text-sm font-medium text-gray-300 mb-1">Name</label>
              <input
                type="text"
                id="name"
                value={name}
                onChange={(e) => setName(e.target.value)}
                className="w-full px-3 py-2 rounded-md bg-gray-700 border border-gray-600 text-white focus:outline-none focus:ring-2 focus:ring-blue-500"
                required
              />
            </div>
            <div>
              <label htmlFor="age" className="block text-sm font-medium text-gray-300 mb-1">Age</label>
              <input
                type="number"
                id="age"
                value={age}
                onChange={(e) => setAge(e.target.value)}
                className="w-full px-3 py-2 rounded-md bg-gray-700 border border-gray-600 text-white focus:outline-none focus:ring-2 focus:ring-blue-500"
                required
              />
            </div>
            <div>
              <label htmlFor="nationality" className="block text-sm font-medium text-gray-300 mb-1">Nationality</label>
              <input
                type="text"
                id="nationality"
                value={nationality}
                onChange={(e) => setNationality(e.target.value)}
                className="w-full px-3 py-2 rounded-md bg-gray-700 border border-gray-600 text-white focus:outline-none focus:ring-2 focus:ring-blue-500"
                required
              />
            </div>
            <div>
              <label htmlFor="experience" className="block text-sm font-medium text-gray-300 mb-1">Experience (years)</label>
              <input
                type="number"
                id="experience"
                value={experience}
                onChange={(e) => setExperience(e.target.value)}
                className="w-full px-3 py-2 rounded-md bg-gray-700 border border-gray-600 text-white focus:outline-none focus:ring-2 focus:ring-blue-500"
                required
              />
            </div>
          </div>
          <div>
            <label htmlFor="preferredFormations" className="block text-sm font-medium text-gray-300 mb-1">Preferred Formations (comma-separated)</label>
            <input
              type="text"
              id="preferredFormations"
              value={preferredFormations}
              onChange={(e) => setPreferredFormations(e.target.value)}
              className="w-full px-3 py-2 rounded-md bg-gray-700 border border-gray-600 text-white focus:outline-none focus:ring-2 focus:ring-blue-500"
              required
            />
          </div>
          <div>
            <label htmlFor="preferredPlayingStyle" className="block text-sm font-medium text-gray-300 mb-1">Preferred Playing Style</label>
            <input
              type="text"
              id="preferredPlayingStyle"
              value={preferredPlayingStyle}
              onChange={(e) => setPreferredPlayingStyle(e.target.value)}
              className="w-full px-3 py-2 rounded-md bg-gray-700 border border-gray-600 text-white focus:outline-none focus:ring-2 focus:ring-blue-500"
              required
            />
          </div>
          <div>
            <label htmlFor="specialties" className="block text-sm font-medium text-gray-300 mb-1">Specialties (comma-separated)</label>
            <input
              type="text"
              id="specialties"
              value={specialties}
              onChange={(e) => setSpecialties(e.target.value)}
              className="w-full px-3 py-2 rounded-md bg-gray-700 border border-gray-600 text-white focus:outline-none focus:ring-2 focus:ring-blue-500"
              required
            />
          </div>
          <button
            type="submit"
            className="w-full bg-yellow-600 hover:bg-yellow-700 text-white font-bold py-3 px-4 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            Add Manager
          </button>
        </form>
      </div>
    </div>
  );
};

export default AddManagerModal;