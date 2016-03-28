using System.Collections.Generic;

namespace OsuReplay.Store
{
    /// <summary>
    /// Represents a key/value store
    /// </summary>
    /// <typeparam name="T">Type of the store values</typeparam>
    public interface IStore<T>
    {
        /// <summary>
        /// Retrieves all the values in the store
        /// </summary>
        /// <returns>An enumerable containing all the values in the store</returns>
        IEnumerable<T> All();

        /// <summary>
        /// Deletes the given value of the store
        /// </summary>
        /// <param name="key">Key of the value to delete</param>
        /// <returns>A task</returns>
        void Delete(string key);

        /// <summary>
        /// Finds the value associated with the given key in the store
        /// </summary>
        /// <param name="key">Key of the value to find</param>
        /// <returns>The value</returns>
        T Find(string key);

        /// <summary>
        /// Stores the given value in the store at the given key
        /// </summary>
        /// <param name="key">Key of the value</param>
        /// <param name="value">Value</param>
        /// <returns>A task</returns>
        void Save(string key, T value);

        /// <summary>
        /// Updates the value at the given key with the new value
        /// </summary>
        /// <param name="key">Key of the value</param>
        /// <param name="value">Value</param>
        /// <returns>A task</returns>
        void Update(string key, T value);
    }
}
