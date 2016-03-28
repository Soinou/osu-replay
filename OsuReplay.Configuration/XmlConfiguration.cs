using System;
using System.Collections.Generic;
using System.Xml.Linq;

namespace OsuReplay.Configuration
{
    public class XmlConfiguration : IConfiguration
    {
        public XmlConfiguration()
        {
            values_ = new Dictionary<string, object>();

            Load();
        }

        public T Get<T>(string key)
        {
            object value = null;

            if (values_.TryGetValue(key, out value))
            {
                try
                {
                    return (T)value;
                }
                catch (InvalidCastException)
                {
                    var message = string.Format(kWrongType, key, typeof(T).Name,
                        value.GetType().Name);

                    throw new ConfigurationException(message);
                }
            }
            else
                throw new ConfigurationException(string.Format(kValueNotFound, key));
        }

        private void AddBoolean(string name, string value)
        {
            switch (value.ToLower())
            {
                case "true":
                case "1":
                case "yes":
                case "on":
                    values_.Add(name, true);
                    break;

                case "false":
                case "0":
                case "no":
                case "off":
                    values_.Add(name, false);
                    break;

                default:
                    throw new ConfigurationException(string.Format(kInvalidBooleanFormat, name, value));
            }
        }

        private void AddFloat(string name, string value)
        {
            float result = 0;

            if (!float.TryParse(value, out result))
                throw new ConfigurationException(string.Format(kInvalidFloatFormat, name, value));
            else
                values_.Add(name, result);
        }

        private void AddInteger(string name, string value)
        {
            int result = 0;

            if (!int.TryParse(value, out result))
                throw new ConfigurationException(string.Format(kInvalidIntegerFormat, name, value));
            else
                values_.Add(name, result);
        }

        private void AddString(string name, string value)
        {
            if (string.IsNullOrEmpty(value))
                throw new ConfigurationException(string.Format(kEmptyString, name));

            values_.Add(name, value);
        }

        private void Load()
        {
            var document = XDocument.Load("Configuration.xml");

            foreach (var element in document.Root.Elements())
            {
                if (element.NodeType == System.Xml.XmlNodeType.Element)
                {
                    var attribute = element.Attribute("name");

                    if (attribute != null)
                    {
                        var name = attribute.Value;
                        var value = element.Value;

                        switch (element.Name.LocalName)
                        {
                            case "Boolean":
                                AddBoolean(name, value);
                                break;

                            case "Integer":
                                AddInteger(name, value);
                                break;

                            case "Float":
                                AddFloat(name, value);
                                break;

                            case "String":
                                AddString(name, value);
                                break;

                            default:
                                break;
                        }
                    }
                }
            }
        }

        private const string kEmptyString = "String '{0}' is empty";
        private const string kInvalidBooleanFormat = "Boolean '{0}' has invalid format '{1}'";
        private const string kInvalidFloatFormat = "Float '{0}' has invalid format '{1}'";
        private const string kInvalidIntegerFormat = "Integer '{0}' has invalid format '{1}'";
        private const string kValueNotFound = "Value '{0}' not found in the configuration file";
        private const string kWrongType = "Expected type '{1}' for '{0}', got '{2}'";
        private Dictionary<string, object> values_;
    }
}
